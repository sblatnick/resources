


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

#// alternative operator
a // b == COALESCE(a, b) == if a then a else b


#Loop through retaining whitespace between tabs by using spaces:
  #use another channel (3) to not get the printf in the loop
  #use IFS=$'\t' for tab delimited from @tsv
  while IFS=$'\t' read -u 3 one two three four
  do
    printf "  \033[34m%-8s\033[0m %-10s %s %s\n" "${one##*.}" "${two}" "${three}" "${four%%.*}"
  #avoid "" by using .attribute // " " so the columns stay aligned in their fields
  done 3< <(jq -r ".[] | select(.one == \"${1}\") | select(.two | contains(\"filter\")) | [.one, .two, .three // \" \", .four // \" \"] | @tsv" ${JSON_FILE})


#Unique array of ids:
jq '[.run.results | .[] | .id] | unique' output.json


#Examples from CodeQL sarif (json) results:

jq '
  .runs[0].tool.driver.rules[
    [.runs[0].results | .[] | .ruleIndex] | unique | .[]
  ].properties |
    select(has("security-severity"))["security-severity"]
    // .["problem.severity"]
' cql.sarif

jq '
  .runs[0].tool.driver.rules as $rules |
  [.runs[0].results | .[] | .ruleIndex] | unique | .[] |
  {
    id: .,
    severity: (
      $rules[.].properties | (
        if has("security-severity")
        then
          .["security-severity"] |
          select(. | tonumber >= 7)
        else
          .["problem.severity"]
        end
      )
    )
  }
' cql.json

jq '
  [
    .runs[0].tool.driver.rules as $rules |
    [.runs[0].results | .[] | .ruleIndex] | unique | .[] |
    {
      id: .,
      severity: (
        $rules[.].properties | (
          if has("security-severity")
          then
            .["security-severity"] |
            select(. | tonumber >= 7)
          else
            .["problem.severity"] |
            select(. | contains("critical", "high"))
          end
        )
      )
    }
  ]
' cql.json

#What I ended up using to get severity counts of critical and high:

json cql.sarif > cql.json
jq '
  [
    .runs[0].tool.driver.rules as $rules |
    [.runs[0].results | .[] | .ruleIndex] | unique | .[] |
    {
      id: .,
      severity: (
        $rules[.].properties | (
          if has("security-severity")
          then
            .["security-severity"] |
            select(. | tonumber >= 7) |
            if . | tonumber >= 9
            then
              "critical"
            else
              "high"
            end
          else
            .["problem.severity"] |
            select(. | contains("critical", "high"))
          end
        )
      )
    }
  ]
' cql.json > findings.json
jq -s '
  [
    .[] |
    group_by(.severity) |
    map({ severity: .[0].severity, count: map(.severity) | length}) |
    .[] |
    {(.severity):.count}
  ] |
  add
' findings.json