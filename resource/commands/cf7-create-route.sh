domain=$(get_option '.domain')
hostname=$(get_option '.hostname')
path=$(get_option '.path')

if [ ! -n "$domain" ]; then
  logger::error "domain is required"
  exit $E_DOMAIN_NOT_SET
fi

args=()
[ -n "$domain" ]     && args+=("$domain")
[ -n "$hostname" ]   && args+=(--hostname "$hostname")
[ -n "$path" ]       && args+=(--path "$path")

logger::info "Executing $(logger::highlight "$command"): "${args[@]}""
cf::target "$org" "$space"

cf7 create-route "${args[@]}"
