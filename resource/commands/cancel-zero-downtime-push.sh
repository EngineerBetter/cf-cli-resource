current_app_name=$(get_option '.current_app_name')

logger::info "Executing $(logger::highlight "$command"): $current_app_name"

cf::target "$org" "$space"

# autopilot (tested v0.0.2 - v0.0.6) doesn't like CF_TRACE=true
CF_TRACE=false cf::cf v3-cancel-zdt-push "$current_app_name"
