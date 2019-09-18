


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

#output array or string on lines:
jq -r ".contexts.\"path\" | if type==\"string\" then [.] else . end | .[]" $file

#put hash in env, using the value of another key as a key:
jq -r '.current as $context | .contexts | .[$context] | .path' $rc
for var in $(jq -r ".contexts | .[\"$target\"] | to_entries | map(\"\(.key)=\(.value|tostring)\") | .[]" $rc); do
  export $var
done

#add to array:
jq ".contexts.wl |= {volumes: [\"test\"]}" example.json
jq ".contexts.wl.volumes |= [\"test\"]" example.json
#handle if string, override:
jq ".contexts.wl.volumes |= if type==\"string\" then \"test\" else [\"test\"] end" example.json

#jo - JSON output from a shell
  #jo helps with object creation:
  jo -p example=$(jo path=/tmp)
    {
       "example": {
          "path": "/tmp"
       }
    }

