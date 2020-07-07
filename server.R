## PHE COVID19 HCAI Dashboard
#   Includes:
#     + data filters for multiple views
#     + data summary indicators
#     + graph of counts
#     + graph of proportions
#     + table of counts and proportions


function(input, output, session) {
  router(input, output, session)

  # SASS
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

      updateSelectInput(
        session = session,
        inputId = "trust_type",
        selected = c(as.character(t$trust_type))
      )

      updateSelectInput(
        session = session,
        inputId = "nhs_region",
        selected = c(as.character(t$nhs_region))
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
      updateSelectInput(
        session = session,
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

  # Template
  valueBox <- function(label,number){
    tagList(
      p(
        class="govuk-!-font-size-16 govuk-!-margin-bottom-0 govuk-caption-m",
        label
      ),
      h3(
        class="govuk-heading-m govuk-!-font-weight-regular govuk-!-margin-bottom-0 govuk-!-padding-top-0",
        number
      )
    )
  }

  output$valuebox_total <- renderUI({
    valueBox(
      "Total",
      paste(sum(vb_data()$n))
    )
  })

  output$valuebox_prop <- renderUI({
    valueBox(
      "Linked",
      paste0(sum(vb_data()$p[vb_data()$linkgrp]),"%")
    )
  })

  output$valuebox_co <- renderUI({
    valueBox(
      "CO",
      paste0(ifelse(any(vb_data()$hcai_group == "CO"),
                    vb_data()$link_p[vb_data()$hcai_group == "CO"],0),
      "%")
    )
  })

  output$valuebox_hoiha <- renderUI({
    valueBox(
      "HO.iHA",
      paste0(ifelse(
        any(vb_data()$hcai_group == "HO.iHA"),
        vb_data()$link_p[vb_data()$hcai_group == "HO.iHA"],
        0
      ),
        "%")
    )
  })

  output$valuebox_hopha <- renderUI({
    valueBox(
      "HO.pHA",
      paste0(ifelse(
        any(vb_data()$hcai_group == "HO.pHA"),
        vb_data()$link_p[vb_data()$hcai_group == "HO.pHA"],
        0
      ),
        "%")
    )
  })

  output$valuebox_hoha <- renderUI({
    valueBox(
      "HO.HA",
      paste0(ifelse(
        any(vb_data()$hcai_group == "HO.HA"),
        vb_data()$link_p[vb_data()$hcai_group == "HO.HA"],
        0
      ),
        "%")
    )
  })

  #### OUTPUT: COUNTS GRAPH #####################################################

  output$plotly_count <-
    renderPlotly({

      plot_count <- data() %>%
        group_by(wk_start, hcai_group) %>%
        summarise(n = sum(n),.groups="drop") %>%
        pivot_wider(
          id_cols = c(wk_start),
          names_from = hcai_group,
          values_from = n,
          values_fill = 0,
          values_fn = sum
        )

      plotly_graph(plot_count)

    })

  #### OUTPUT: PROPORTIONS GRAPH ################################################

  output$plotly_proportion <-
    renderPlotly({

      plot_prop <- data() %>%
        group_by(wk_start, hcai_group) %>%
        summarise(n = sum(n),.groups="keep") %>%
        ungroup(hcai_group) %>%
        mutate(p=n/sum(n)) %>%
        pivot_wider(
          id_cols = c(wk_start),
          names_from = hcai_group,
          values_from = p,
          values_fill = 0,
          values_fn = sum
        )

      plotly_graph(plot_prop)

    })

  #### OUTPUT: DATA TABLE #######################################################
  output$data_table <-
    DT::renderDataTable({
      dt <- data() %>%
        group_by(wk_start, wk, hcai_group, provider_code) %>%
        summarise(n = sum(n),.groups="keep") %>%
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
          # wk,
          Week=wk_start,
          # Cumulative_Total = cT,
          Total = wT,
          ends_with("CO.pHA"),
          ends_with("CO"),
          ends_with("HO.iHA"),
          ends_with("HO.pHA"),
          ends_with("HO.HA"),
          ends_with("Unlinked")
        )

      names(dt) <- sapply(sapply(strsplit(names(dt), "p_"), rev), paste, collapse=" %")
      names(dt) <- sapply(sapply(strsplit(names(dt), "n_"), rev), paste, collapse=" n")

      DT::datatable(
        dt,
        extensions = 'Buttons',
        options=list(pageLength=25,
          dom = 'Bfrtip',
          buttons=c('copy','csv')),
        rownames = FALSE) %>%
        DT::formatPercentage(grep("%",names(dt)),1)

    })

  #### TEXT STRING FOR DISPLAY ##################################################
  output$data_for_text <- renderText({

    t <- paste(
      "Data for",
      case_when(
        input$trust_name == "ALL" & input$trust_type == "ALL" ~ "all Providers",
        input$trust_name == "ALL" & input$trust_type != "ALL" ~
          paste("all",input$trust_type,"Providers"),
        TRUE ~ input$trust_name
      ),
      "in",
      case_when(
        input$nhs_region == "LONDON" ~ input$nhs_region,
        input$nhs_region != "ALL" ~ paste("the",input$nhs_region),
        TRUE ~ "England"
      )
      )

    t <- stringr::str_to_title(t)

    t <- stringr::str_replace_all(t,"Nhs","NHS")

    for(lower in c("All","Of","The","For","In")) {
      t <- stringr::str_replace_all(t,lower,stringr::str_to_lower(lower))
    }
  })

}

