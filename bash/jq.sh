


#jq takes json and allows you to parse it:
curl -sn 'https://api.com/node?name=test' | \
jq -r '.[] | select(.os != null and .os != "") | [.name,.os] | @csv'

# -r             = raw output (no quotes, although @csv adds them back in)
# .[]            = all elements of array
# |              = pipe to next action
# select()       = only keep elements matching the selection
# .os            = json property for object.image
# [.name,.os]    = creates an array using those properties

auth.json:
  {
    "username": "user",
    "password": "secret"
  }

IFS=$'\n' read -rd '' username password <<< "$(jq -r '.username, .password' auth.json)"
