app_name=$(get_option '.app_name')
buildpack=$(get_option '.buildpack')
startup_command=$(get_option '.startup_command')
docker_image=$(get_option '.docker_image')
docker_username=$(get_option '.docker_username')
docker_password=$(get_option '.docker_password')
manifest=$(get_option '.manifest')
instances=$(get_option '.instances')
disk_quota=$(get_option '.disk_quota')
memory=$(get_option '.memory')
no_start=$(get_option '.no_start')
path=$(get_option '.path')
stack=$(get_option '.stack')
vars=$(get_option '.vars')
vars_files=$(get_option '.vars_files')
staging_timeout=$(get_option '.staging_timeout' 0)
startup_timeout=$(get_option '.startup_timeout' 0)

if [ ! -f "$manifest" ]; then
  logger::error "invalid payload (manifest is not a file: $manifest)"
  exit $E_MANIFEST_FILE_NOT_FOUND
fi

args=()
[ -n "$app_name" ]        && args+=("$app_name")
[ -n "$buildpack" ]       && args+=(-b "$buildpack")
[ -n "$startup_command" ] && args+=(-c "$startup_command")
[ -n "$docker_image" ]    && args+=(--docker-image "$docker_image")
[ -n "$docker_username" ] && args+=(--docker-username "$docker_username")
[ -n "$docker_password" ] && export CF_DOCKER_PASSWORD="$docker_password"
[ -n "$manifest" ]        && args+=(-f "$manifest")
[ -n "$instances" ]       && args+=(-i "$instances")
[ -n "$disk_quota" ]      && args+=(-k "$disk_quota")
[ -n "$memory" ]          && args+=(-m "$memory")
[ -n "$no_start" ]        && args+=(--no-start)
[ -n "$path" ]            && args+=(-p $path) # don't quote so we can support globbing
[ -n "$stack" ]           && args+=(-s "$stack")

for key in $(echo $vars | jq -r 'keys[]'); do
  value=$(echo $vars | jq -r --arg key "$key" '.[$key]')
  args+=(--var "$key=$value")
done

for vars_file in $(echo $vars_files | jq -r '.[]'); do
  args+=(--vars-file "$vars_file")
done

logger::info "Executing $(logger::highlight "$command"): $app_name"
cf::target "$org" "$space"

[ "$staging_timeout" -gt "0" ] && export CF_STAGING_TIMEOUT=$staging_timeout
[ "$startup_timeout" -gt "0" ] && export CF_STARTUP_TIMEOUT=$startup_timeout

cf7 push --strategy rolling "${args[@]}"
