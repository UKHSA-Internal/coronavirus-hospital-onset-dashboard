## PHE COVID19 HCAI Dashboard
#   Includes:
#     + data filters for multiple views
#     + data summary indicators
#     + graph of counts
#     + graph of proportions
#     + table of counts and proportions

function(input, output, session) {

  # SASS

  sass::sass(
    sass::sass_file("styles/govuk/all.scss"),
    output = "www/govuk.css"
  )

  sass::sass(
    sass::sass_file("styles/main.scss"),
    output = "www/main.css"
  )

  #### DASHBOARD DATA ###########################################################
  unfiltered <- reactive({
    ## filter dates always
    d <- hcai %>%
      filter(wk_start >= input$date_filter) %>%
      ungroup()

    ## NHS region
    if (input$nhs_region == "ALL") {
      d <- d

    } else {
      d <- d %>% filter(nhs_region == as.character(input$nhs_region))

    }

    ## trust type
    if (as.character(input$trust_type) == "ALL") {
      d <- d

    } else {
      d <- d %>% filter(trust_type == as.character(input$trust_type))

    }

    ## deal with linked/unlinked data
    if (input$link == 0) {
      d <- d %>% filter(hcai_group != "Unlinked")

    } else {
      d <- d
    }

  })

  ## FILTER THE DATA
  data <- reactive({
    d <- unfiltered()

    ## trust code
    if (as.character(input$trust_code) == "ALL") {
      d <- d %>% mutate(provider_code = "ALL")

    } else {
      d <- d %>% filter(provider_code == as.character(input$trust_code))
    }

  })

  #### REACTIVE FILTERS FOR UI ##################################################
  # update menus
  observeEvent(input$nhs_region, {

    updateSelectInput(
      session = session,
      inputId = "trust_name",
      choices = c("ALL",levels(factor(unfiltered()$trust_name)))
    )
    updateSelectInput(
      session = session,
      inputId = "trust_code",
      choices = c("ALL",levels(factor(unfiltered()$provider_code)))
    )

  })


  observeEvent(input$trust_type, {

    updateSelectInput(
      session = session,
      inputId = "trust_code",
      choices = c("ALL",levels(factor(unfiltered()$provider_code)))
    )
    updateSelectInput(
      session = session,
      inputId = "trust_name",
      choices = c("ALL",levels(factor(unfiltered()$trust_name)))
    )
  }
  )

  observeEvent(input$trust_code,{

    if (input$trust_code != "ALL") {
      t <- unfiltered() %>% filter(provider_code == input$trust_code)

      updateSelectInput(
        session = session,
        inputId = "trust_name",
        selected = c(levels(factor(as.character(t$trust_name))))
      )

    } else {
      updateSelectInput(session = session,
        inputId = "trust_name",
        selected = c("ALL"))
    }
  }
  )

  observeEvent(input$trust_name, {
    if (input$trust_name != "ALL") {
      t <- unfiltered() %>% filter(trust_name == input$trust_name)

      updateSelectInput(
        session = session,
        inputId = "trust_code",
        selected = c(as.character(t$provider_code))
      )

    } else {
      updateSelectInput(session = session,
        inputId = "trust_name",
        selected = c("ALL"))

    }
  })

  #### VALUE BOX REACTIVE DATA ##################################################
  vb_data <- reactive({


    ## NHS region
    if(input$nhs_region=="ALL"){
      vb <- hcai %>%
        ungroup()

    } else {
      vb <- hcai %>%
        ungroup() %>%
        filter(nhs_region == as.character(input$nhs_region))

    }

    ## trust type
    if (input$trust_type == "ALL") {
      vb <- vb %>%
        ungroup()

    } else {
      vb <- vb %>%
        ungroup() %>%
        filter(trust_type == as.character(input$trust_type))

    }

    ## trust code
    if (input$trust_code == "ALL") {
      vb <- vb

    } else {
      vb <- vb %>%
        filter(provider_code == as.character(input$trust_code))
    }

    ## group up data
    vb <- vb %>%
      mutate(linkgrp = hcai_group != "Unlinked") %>%
      group_by(linkgrp, hcai_group) %>%
      summarise(n = sum(n),.groups="drop") %>%
      group_by(linkgrp) %>%
      mutate(link_t = sum(n),
        link_p = round(n / link_t * 100, 1)) %>%
      ungroup() %>%
      mutate(t = sum(n),
        p = round(n / t * 100, 1))
  })


  #### VALUE BOXES FOR DATA INDICATORS ##########################################
  output$valuebox_total <- renderUI({
    div(style="padding: 10px",
      h2(paste(sum(vb_data()$n))),
      p("Total cases")
    )
  })

  output$valuebox_prop <- renderUI({
    div(style="padding: 10px",
      h2(paste0(sum(vb_data()$p[vb_data()$linkgrp]),
        "%")),
      p("Cases linked")
    )
  })

  output$valuebox_co <- renderUI({
    div(style="padding: 10px",
      h2(paste0(ifelse(
        any(vb_data()$hcai_group == "CO"),
        vb_data()$link_p[vb_data()$hcai_group == "CO"],
        0
      ),
        "%")),
      p("CO")
    )
  })

  output$valuebox_hoiha <- renderUI({
    div(style="padding: 10px",
      h2(paste0(ifelse(
        any(vb_data()$hcai_group == "HO.iHA"),
        vb_data()$link_p[vb_data()$hcai_group == "HO.iHA"],
        0
      ),
        "%")),
      p("HO.iHA")
    )
  })

  output$valuebox_hopha <- renderUI({
    div(style="padding: 10px",
      h2(paste0(ifelse(
        any(vb_data()$hcai_group == "HO.pHA"),
        vb_data()$link_p[vb_data()$hcai_group == "HO.pHA"],
        0
      ),
        "%")),
      p("HO.pHA")
    )
  })

  output$valuebox_hoha <- renderUI({
    div(style="padding: 10px",
      h2(paste0(ifelse(
        any(vb_data()$hcai_group == "HO.HA"),
        vb_data()$link_p[vb_data()$hcai_group == "HO.HA"],
        0
      ),
        "%")),
      p("HO.HA")
    )
  })




  #### OUTPUT: COUNTS GRAPH #####################################################
  output$plot_count <-
    renderPlotly({

      hcai_week <-
        data() %>%
        group_by(wk_start, hcai_group, provider_code) %>%
        summarise(n = sum(n),.groups = "keep")  %>%
        ggplot(aes(x = wk_start,
          y = n,
          fill = hcai_group)) +
        geom_bar(stat = "identity",
          width=6) +
        scale_fill_manual(
          values = c(
            "Unlinked" = "#b1b4b6",
            "CO" = "#5694ca",
            "HO.iHA" = "#ffdd00",
            "HO.pHA" = "#003078",
            "HO.HA" = "#d4351c"
          )
        ) +
        scale_x_date(
          "COVID19 Positive Test (Week Commencing; 2020)",
          breaks = seq(min(data()$wk_start)-7, max(data()$wk_start)+7, 7),
          date_labels = "%d %b",
          expand = expansion(add = 1)
        ) +
        scale_y_continuous("Total number of cases",
          breaks = function(x, n = 5) pretty(x, n)[pretty(x, n) %% 1 == 0]) +
        theme_classic() +
        guides(fill = guide_legend(nrow = 1)) +
        theme(legend.position = "bottom",
          panel.background = element_rect(fill="#f8f8f8"),
          plot.background = element_rect(fill="#f8f8f8"),
          legend.background = element_rect(fill="#f8f8f8")
        )

      ggplotly(hcai_week) %>%
        layout(hovermode = "x unified",
          font=font_style) %>%
        config(displaylogo = FALSE,
          modeBarButtons = list(list("toImage"))) %>%
        layout(legend = list(orientation = 'h',
          y = '1.15',
          title=list(text="HCAI category")
        ))

    })

  #### OUTPUT: PROPORTIONS GRAPH ################################################
  output$plot_proportion <-

    renderPlotly({

      if (input$trust_code=="ALL" & input$trust_type == "ALL" & input$link==1) {

        # give all data as proportion linked
        link_prop <- data() %>%
          group_by(linkset, wk_start, wk, provider_code) %>%
          summarise(n = sum(n),.groups="drop") %>%
          group_by(wk_start, wk, provider_code) %>%
          mutate(total = sum(n),
            p = round(n / total * 100, digits = 1)) %>%
          ggplot(aes(x = wk_start,
            y = p,
            fill = linkset)) +
          geom_bar(stat = "identity",
            width=6) +
          scale_x_date(
            "COVID19 Positive Test (Week Commencing; 2020)",
            breaks = seq(min(data()$wk_start)-7, max(data()$wk_start)+7, 7),
            date_labels = "%d %b",
            expand = expansion(add = 1)
          ) +
          scale_y_continuous("Proportion of cases (%)",
            labels = function(x) paste0(x, "%")) +
          scale_fill_manual(
            values = c(
              "SGSS:SUS:ECDS" = "#002549",
              "SGSS:SUS" = "#005EB8",
              "SGSS:ECDS" = "#4c8ecd",
              "SGSS" = "#C3C3C3"
            )
          ) +
          theme_classic() +
          theme(legend.position = "bottom")

        ggplotly(link_prop) %>%
          layout(hovermode = "compare",
            font=font_style) %>%
          config(displaylogo = FALSE,
            modeBarButtons = list(list("toImage"))) %>%
          layout(legend = list(orientation = 'h',
            y = '1.15',
            title=list(text="Datasets linked")
          ))

      } else {

        ## or if one trust breakdown props per day since we cannot attribute unlinked
        hcai_week_p <-
          data() %>%
          group_by(wk_start, hcai_group, provider_code) %>%
          summarise(n = sum(n),.groups="drop") %>%
          group_by(wk_start, provider_code) %>%
          mutate(p = round(n / sum(n) * 100, 1)) %>%
          ggplot(aes(x = wk_start,
            y = p,
            fill = hcai_group)) +
          geom_bar(stat = "identity",
            width = 6) +
          scale_fill_manual(
            values = c(
              "Unlinked" = "#C3C3C3",
              "CO.pHA" = "#003087",
              "CO" = "#00B092",
              "HO.iHA" = "#425563",
              "HO.pHA" = "#EAAB00",
              "HO.HA" = "#822433"
            )
          ) +
          scale_x_date(
            "COVID19 Positive Test (Week Commencing; 2020)",
            breaks = seq(min(data()$wk_start)-7, max(data()$wk_start)+7, 7),
            date_labels = "%d %b",
            expand = expansion(add = 1)
          ) +
          scale_y_continuous("Proportion of cases (%)",
            labels = function(x) paste0(x, "%")) +
          theme_classic() +
          guides(fill = guide_legend(nrow = 1)) +
          theme(legend.position = "bottom")

        ggplotly(hcai_week_p) %>%
          layout(hovermode = "compare",
            font=font_style) %>%
          config(displaylogo = FALSE,
            modeBarButtons = list(list("toImage"))) %>%
          layout(legend = list(orientation = 'h',
            y = '1.15',
            title=list(text="HCAI category")
          ))




      }
    })

  #### OUTPUT: DATA TABLE #######################################################
  output$data_table <-
    DT::renderDataTable({
      dt <- data() %>%
        group_by(wk_start, wk, hcai_group, provider_code) %>%
        summarise(n = sum(n),.groups="drop") %>%
        group_by(wk, wk_start) %>%
        mutate(wT = sum(n),
          p = n / wT) %>%
        arrange(hcai_group) %>%
        pivot_wider(
          id_cols = c(wk, wk_start, wT),
          names_from = hcai_group,
          values_from = c(n, p),
          values_fill = list(n = 0, p = 0)
        ) %>%
        arrange(wk_start) %>%
        ungroup() %>%
        mutate(cT = cumsum(wT)) %>%
        arrange(desc(wk_start)) %>%
        select(
          wk,
          wk_start,
          Cumulative_Total = cT,
          wk_Total = wT,
          ends_with("CO.pHA"),
          ends_with("CO"),
          ends_with("HO.iHA"),
          ends_with("HO.pHA"),
          ends_with("HO.HA"),
          ends_with("Unlinked")
        )

      names(dt) <- sapply(sapply(strsplit(names(dt), "p_"), rev), paste, collapse="_%")
      names(dt) <- sapply(sapply(strsplit(names(dt), "n_"), rev), paste, collapse="_n")

      DT::datatable(dt,
        extensions = 'Buttons',
        options=list(pageLength=25,
          dom = 'Bfrtip',
          buttons=c('copy','csv')),
        caption = paste(
          "Data for",
          case_when(
            input$trust_name == "ALL" &
              input$trust_type == "ALL" ~ "all Providers",
            input$trust_name == "ALL" &
              input$trust_type != "ALL" ~ paste("all",
                input$trust_type,
                "Providers"),
            TRUE ~ input$trust_name
          )),

        rownames = FALSE) %>%
        DT::formatPercentage(grep("%",names(dt)),1)

    })

}
