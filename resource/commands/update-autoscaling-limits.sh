app_name=$(get_option '.app_name')
min_instance_limit=$(get_option '.min_instance_limit')
max_instance_limit=$(get_option '.max_instance_limit')


args=()
[ -n "$app_name" ]        && args+=("$app_name")
[ -n "$min_instance_limit" ]        && args+=("$min_instance_limit")
[ -n "$max_instance_limit" ]        && args+=("$max_instance_limit")


logger::info "Executing $(logger::highlight "$command"): $app_name"
cf::target "$org" "$space"

cf::cf update-autoscaling-limits "${args[@]}"
