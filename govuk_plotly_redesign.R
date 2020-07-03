## OUTPUT: COUNT DATA ###########################################################
pd <- hcai %>%
  pivot_wider(
    id_cols = c(wk_start),
    names_from = hcai_group,
    values_from = n,
    values_fill = 0,
    values_fn = sum
  )
pd



## OUTPUT: PROPORTION DATA ######################################################
pd_prop <- hcai %>%
  group_by(wk_start,hcai_group) %>%
  summarise(n=sum(n)) %>%
  ungroup(hcai_group) %>%
  mutate(p=n/sum(n)) %>%
  pivot_wider(
    id_cols = c(wk_start),
    names_from = hcai_group,
    values_from = p,
    values_fill = 0,
    values_fn = sum
  )

hcai %>%
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


## OUTPUT: GRAPH ################################################################

plotly_graph <- function(data) {

  p <- plot_ly(type='bar')

  for(col in c("CO","HO.iHA","HO.pHA","HO.HA","Unlinked")) {
    if(col %in% names(data)) {
      p <- p %>%
        add_trace(x=data$wk_start,
                  y=data[[col]],
                  name=col,
                  text = case_when(
                    col=="CO" ~ "Community onset",
                    col=="HO.iHA" ~ "Hospital onset indeterminate healthcare associated",
                    col=="HO.pHA" ~ "Hospital onset probable healthcare associated",
                    col=="HO.HA" ~ "Hospital onset healthcare associated",
                    TRUE ~ "No hospital record"
                  ),
                  hovertemplate = '%{text}: %{y}',
                  marker = list(
                    color = case_when(
                      col=="CO" ~ "#5694ca",
                      col=="HO.iHA" ~ "#ffdd00",
                      col=="HO.pHA" ~ "#003078",
                      col=="HO.HA" ~ "#d4351c",
                      TRUE ~ "#b1b4b6"
                    )
                  ))
    }
  }

  if(max(data$CO)<1) {
    p <- p %>% layout(yaxis = list(tickformat = "%"))
  } else {
    p <- p %>% layout(yaxis = list(tickformat = ",digit"))

  }

  p <- p %>%
    layout(
      title = list(text = "<b>Patients first positive COVID-19 test, by HCAI category</b>",
                   xref="container",
                   x=0.01,
                   y=0.9),
      barmode = 'stack',
      hovermode = 'x unified',
      font = font_style,
      legend = list(orientation = 'h',
                    y = '-0.2'),
      plot_bgcolor = '#f8f8f8',
      paper_bgcolor = '#f8f8f8',
      margin = list(l = 60,
                    r = 25,
                    b = 40,
                    t = 90,
                    pad = 5)
      ) %>%
    config(displaylogo = FALSE,
           modeBarButtons = list(list("toImage")))


  return(p)
}

plotly_graph(pd_prop)
plotly_graph(pd)

## OLD STYLE ####################################################################

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

