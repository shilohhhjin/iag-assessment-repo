{% macro incremental_filter_by_id_and_recent_date(
    id_column='post_id',
    date_column='creation_date',
    months=12,
    table=none
) %}
  {% if is_incremental() %}
    and {{ id_column }} > (
      select max({{ id_column }})
      from {{ table if table is not none else this }}
    )
    and {{ date_column }} >= date_trunc('month', current_date - interval '{{ months }} months')
  {% endif %}
{% endmacro %}