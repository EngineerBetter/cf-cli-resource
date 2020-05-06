app_name=$(get_option '.app_name')

args=()
[ -n "$app_name" ]        && args+=("$app_name")

logger::info "Executing $(logger::highlight "$command"): $app_name"
cf::target "$org" "$space"

cf::cf delete-autoscaling-rules "${args[@]}" --force
