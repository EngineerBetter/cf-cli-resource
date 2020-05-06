app_name=$(get_option '.app_name')
rule_type=$(get_option '.rule_type')
min_threshold=$(get_option '.min_threshold')
max_threshold=$(get_option '.max_threshold')
subtype=$(get_option '.subtype')
metric=$(get_option '.metric')
comparison_metric=$(get_option '.comparison_metric')

args=()
[ -n "$app_name" ]        && args+=("$app_name")
[ -n "$rule_type" ]        && args+=("$rule_type")
[ -n "$min_threshold" ]        && args+=("$min_threshold")
[ -n "$max_threshold" ]        && args+=("$max_threshold")
[ -n "$subtype" ]        && args+=(--subtype "$subtype")
[ -n "$metric" ]        && args+=(--metric "$metric")
[ -n "$comparison_metric" ]        && args+=(--comparison-metric "$comparison_metric")

logger::info "Executing $(logger::highlight "$command"): $app_name"
cf::target "$org" "$space"

cf::cf create-autoscaling-rule "${args[@]}"
