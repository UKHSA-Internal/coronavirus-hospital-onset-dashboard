## OUTPUT: COUNT GRAPH ##########################################################
pd <- hcai %>%
  pivot_wider(
    id_cols = c(wk_start),
    names_from = hcai_group,
    values_from = n,
    values_fill = 0,
    values_fn = sum
  )
pd

p1 <- plot_ly(type='bar')

for(col in c("CO","HO.iHA","HO.pHA","HO.HA","Unlinked")) {
  if(col %in% names(pd)) {
    p1 <- p1 %>%
      add_trace(x=pd$wk_start,
                y=pd[[col]],
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
p1 <- p1 %>%
  layout(
    yaxis = list(title = "Total number of cases",
                 tickformat = ",digit"),
    xaxis = list(title = "COVID19 Positive Test (Week commencing)"),
    barmode = 'stack',
    hovermode = 'x unified',
    font = font_style,
    legend = list(orientation = 'h',
                  y = '-0.2',
                  title=list(text="HCAI category")),
    plot_bgcolor = '#E7E7E7',
    paper_bgcolor = '#E7E7E7'
    ) %>%
  config(displaylogo = FALSE,
         modeBarButtons = list(list("toImage")))
p1

p2 <- plot_ly()

for(col in c("CO","HO.iHA","HO.pHA","HO.HA","Unlinked")) {
  if(col %in% names(pd)) {
    p2 <- p2 %>%
      add_trace(x=pd_prop$wk_start,
                y=pd_prop[[col]],
                name=col,
                type='bar',
                marker = list(
                  color = case_when(
                    col=="CO" ~ "#5694ca",
                    col=="HO.iHA" ~ "#ffdd00",
                    col=="HO.pHA" ~ "#003078",
                    col=="HO.HA" ~ "#d4351c",
                    TRUE ~ "#b1b4b6"
                  ),
                  showlegend = FALSE
                ))
  }
}

## OUTPUT: PROPORTION GRAPH #####################################################
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


p2 <- p2 %>%
  layout(
    yaxis = list(title = "Proportion of cases",
                 tickformat = "%"),
    xaxis = list(title = "COVID19 Positive Test (Week commencing)"),
    legend = list(title = list(text = "HCAI category")),
    hovermode = "x unified",
    font = font_style,
    barmode = 'stack',
    legend = list(orientation = 'h',
                  y = '-0.2',
                  title=list(text="HCAI category")
    )) %>%
  config(displaylogo = FALSE,
         modeBarButtons = list(list("toImage")))

p2
