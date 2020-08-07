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
      d <- d %>% filter(hcai_group != unlinked)

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

  observeEvent(input$reset, {
    updateSelectInput(
      session = session,
      inputId = "nhs_region",
      selected = "ALL"
    )
    updateSelectInput(
      session = session,
      inputId = "trust_type",
      selected = "ALL"
    )
    updateSelectInput(
      session = session,
      inputId = "trust_name",
      selected = "ALL"
    )
    updateSelectInput(
      session = session,
      inputId = "trust_code",
      selected = "ALL"
    )
    updateSelectInput(
      session = session,
      inputId = "link",
      selected = 0
    )
  })

  observeEvent(input$nhs_region, {

    updateSelectInput(
      session = session,
      inputId = "trust_name",
      choices = c("ALL", levels(factor(unfiltered()$trust_name))),
      selected = ifelse(input$trust_code %in% levels(factor(unfiltered()$provider_code)),
                        input$trust_name,"ALL")
    )
    updateSelectInput(
      session = session,
      inputId = "trust_code",
      choices = c("ALL", levels(factor(unfiltered()$provider_code))),
      selected = ifelse(input$trust_code %in% levels(factor(unfiltered()$provider_code)),
                        input$trust_code,"ALL")
      )
  })


  observeEvent(input$trust_type, {
    if(input$trust_code!="ALL"){
      updateSelectInput(
        session = session,
        inputId = "trust_code",
        choices = c("ALL",levels(factor(unfiltered()$provider_code))),
        selected = ifelse(input$trust_code %in% levels(factor(unfiltered()$provider_code)),
                          input$trust_code,"ALL")
      )
      updateSelectInput(
        session = session,
        inputId = "trust_name",
        choices = c("ALL",levels(factor(unfiltered()$trust_name))),
        selected = ifelse(input$trust_code %in% levels(factor(unfiltered()$provider_code)),
                          input$trust_name,"ALL")
      )
    } else {
      updateSelectInput(
        session = session,
        inputId = "trust_code",
        choices = c("ALL",levels(factor(unfiltered()$provider_code))),
        selected = "ALL"
      )
      updateSelectInput(
        session = session,
        inputId = "trust_name",
        choices = c("ALL",levels(factor(unfiltered()$trust_name))),
        selected = "ALL"
      )
    }
  }
  )

  observeEvent(input$trust_code,{
    if (is.null(input$trust_code)) {
      updateSelectInput(
        session = session,
        inputId = "trust_code",
        selected = "ALL"
      )
    } else if (input$trust_code != "ALL") {
    tn <- unfiltered() %>%
      filter(provider_code == input$trust_code) %>%
      distinct(trust_name,provider_code,trust_type,nhs_region)

      updateSelectInput(
        session = session,
        inputId = "trust_name",
        selected = c(as.character(tn$trust_name))
      )

      updateSelectInput(
        session = session,
        inputId = "trust_type",
        selected = c(as.character(tn$trust_type))
      )

      updateSelectInput(
        session = session,
        inputId = "nhs_region",
        selected = c(as.character(tn$nhs_region))
      )
    } else {
      updateSelectInput(
        session = session,
        inputId = "trust_name",
        selected = input$trust_name)
    }
  }
  )

  observeEvent(input$trust_name, {

    if (input$trust_name != "ALL") {
    pc <- unfiltered() %>%
      filter(trust_name == input$trust_name) %>%
      distinct(provider_code) %>% pull()

      updateSelectInput(
        session = session,
        inputId = "trust_code",
        selected = c(as.character(pc))
      )

    } else {
      updateSelectInput(
        session = session,
        inputId = "trust_name",
        selected = "ALL"
        )
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
      mutate(linkgrp = hcai_group != unlinked) %>%
      group_by(linkgrp, hcai_group) %>%
      summarise(n = sum(n),.groups="drop") %>%
      group_by(linkgrp) %>%
      mutate(link_t = sum(n),
        link_p = round(n / link_t * 100, 1)) %>%
      ungroup() %>%
      mutate(t = sum(n),
        p = round(n / t * 100, 1))
  })

  reporting_indicator <- reactive({

    rp <- data() %>%
      mutate(
        ecds_timely = ifelse(
          ecds_last_update >= wk_start & !is.na(ecds_last_update), 1, 0),
        sus_timely = ifelse(
          sus_last_update >= wk_start & !is.na(sus_last_update), 1, 0
        )
      ) %>%
      group_by(nhs_region, provider_code, wk_start) %>%
      summarise(ecds_timely = max(ecds_timely,na.rm=T),
                sus_timely = max(sus_timely,na.rm=T),
                .groups="drop") %>%
      group_by(wk_start) %>%
      summarise(n_trusts_ecds = sum(ecds_timely),
                n_trusts_sus = sum(sus_timely),
                .groups="drop") %>%
      mutate(
        pc_trust_rptng_ecds = (n_trusts_ecds / max(n_trusts_ecds,na.rm=T)) * 100,
        pc_trust_rptng_sus = (n_trusts_sus / max(n_trusts_sus,na.rm=T)) * 100
      )

  })

  report_prop_cutoff <- 75

  ecds_reporting <- reactive({
    rp <- reporting_indicator() %>%
      filter(pc_trust_rptng_ecds >= report_prop_cutoff) %>%
      filter(wk_start == max(wk_start)) %>%
      pull(wk_start)
  })

  sus_reporting <- reactive({
    rp <- reporting_indicator() %>%
      filter(pc_trust_rptng_sus >= report_prop_cutoff) %>%
      filter(wk_start == max(wk_start)) %>%
      pull(wk_start)
  })

  #### VALUE BOXES FOR DATA INDICATORS ##########################################

  output$valuebox_total <- renderUI({
    valueBox(
      label = "Total",
      number = paste(formatC(sum(vb_data()$n),format="f",big.mark=",",digits=0)),
      tooltipText = "Total COVID-19 infections reported by NHS laboratories"
    )
  })

  output$valuebox_prop <- renderUI({
    valueBox(
      label = "Linked",
      number = paste0(sum(vb_data()$p[vb_data()$linkgrp]),"%"),
      tooltipText = "Proportion of COVID-19 cases linked to a hospital record"
    )
  })

  output$valuebox_co <- renderUI({
    valueBox(
      label = "CO",
      number = paste0(ifelse(any(vb_data()$hcai_group == "CO"),
        vb_data()$link_p[vb_data()$hcai_group == "CO"],0),"%"),
      tooltipText = "Proportion of linked cases which are Community Onset (CO)"
    )
  })

  output$valuebox_hoiha <- renderUI({
    valueBox(
      label = "HO.iHA",
      number = paste0(ifelse(any(vb_data()$hcai_group == "HO.iHA"),
        vb_data()$link_p[vb_data()$hcai_group == "HO.iHA"],0),"%"),
      tooltipText = "Proportion of linked cases which are Hospital-Onset Indeterminate Healthcare-Associated (HO.iHA)"
    )
  })

  output$valuebox_hopha <- renderUI({
    valueBox(
      label = "HO.pHA",
      number = paste0(ifelse(any(vb_data()$hcai_group == "HO.pHA"),
        vb_data()$link_p[vb_data()$hcai_group == "HO.pHA"],0),"%"),
      tooltipText = "Proportion of linked cases which are Hospital-Onset Probable Healthcare-Associated (HO.pHA)"
    )
  })

  output$valuebox_hoha <- renderUI({
    valueBox(
      label = "HO.HA",
      number = paste0(ifelse(any(vb_data()$hcai_group == "HO.HA"),
        vb_data()$link_p[vb_data()$hcai_group == "HO.HA"],0),"%"),
      tooltipText = "Proportion of linked cases which are Hospital-Onset Healthcare-Associated (HO.HA)"
    )
  })

  output$valuebox_ecds <- renderUI({
    valueBox(
      label = "A&E attendance data",
      number = format(ecds_reporting(),"%d %b %Y"),
      tooltipText = ifelse(
        input$trust_code=="ALL",
        "75% of Trusts reporting ECDS A&E data",
        "Most recent ECDS A&E data submission"
        )
    )
  })
  output$valuebox_sus <- renderUI({
    valueBox(
      label = "Admitted patient data",
      number = format(sus_reporting(),"%d %b %Y"),
      tooltipText = ifelse(
        input$trust_code=="ALL",
        "75% of Trusts reporting SUS hospital inpatient data",
        "Most recent SUS hospital inpatient data submission"
      )
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

  no_data_msg <- "There is no data for this selection; please change your filters."

  output$plotly_proportion <-

    renderPlotly({

      validate(
        need(nrow(data()) > 0, no_data_msg)
      )

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

      validate(
        need(nrow(data()) > 0, no_data_msg)
      )

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
          Week=wk_start,
          Total = wT,
          ends_with("CO.pHA"),
          ends_with("CO"),
          ends_with("HO.iHA"),
          ends_with("HO.pHA"),
          ends_with("HO.HA"),
          ends_with(unlinked)
        )

      ## rename variables with prefix to suffix
      names(dt) <- sapply(sapply(strsplit(names(dt), "p_"), rev), paste, collapse=" %")
      names(dt) <- sapply(sapply(strsplit(names(dt), "n_"), rev), paste, collapse=" n")
      names(dt) <- str_replace_all(names(dt),unlinked,"No link")

      DT::datatable(
        dt,
        extensions = 'Buttons',
        options=list(
          pageLength=25,
          dom = "Bfr<'table-container't>ip",
          buttons=c('csv'),
          searching = FALSE),
        rownames = FALSE) %>%
        DT::formatPercentage(grep("%",names(dt)),1)

    })

  ####################

  output$data_rows <- renderText({
    HTML(nrow(data()))
  })


  ####################

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

    HTML(t)

  })

  output$chart_description_text <- renderText({

    t <- paste(
      "Chart showing the breakdown number of COVID-19 cases by HCAI category:",
      ifelse(
        input$link==1,
        "those with no hospital record, CO, HO.iHA, HO.pHA and HO.HA.",
        "CO, HO.iHA, HO.pHA and HO.HA."
      )
    )
    HTML(t)

  })

}

