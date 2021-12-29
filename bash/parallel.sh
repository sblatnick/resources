#::::::::::::::::::::JOBS::::::::::::::::::::

Ctrl+Z                          #background process
$ jobs                          #list jobs
[1]+  Stopped    ./script.sh
$ bg %1                         #run in background
[1]+ ./script.sh &
$ %1 &                          #run in background (alternate method)
[1]+ ./script.sh &
$ fg %1                         #run in forground
$ jobs
[1]+  Running    ./script.sh &
$ disown -h                     #move to nohup, so you can close shell
$ disown -h %1


disown [-ar] [-h] [jobspec ...]
       #no args, disowns "current" job
  -h   #keeps jobs in table, but doesn't send SIGHUP when exiting
  -a   #all jobs
  -r   #running jobs

#::::::::::::::::::::NOHUP::::::::::::::::::::

nohup command   #run in background, disowned, logging stdout/err to nohup.out
nohup command & #same, except show in jobs list
fg %1           #move command into forground
kill -9 $pid    #kill by process id

#Source: https://www.computerhope.com/unix/unohup.htm

#::::::::::::::::::::NICE::::::::::::::::::::

#Change priority of a process
nice command      #run command as a priority 10 (nice default)
nice -n13 command #run command as a priority 13

#Range:
# -20  most favorable to the process
#  19  least favorable to the process

#Source: https://www.computerhope.com/unix/unice.htm

#::::::::::::::::::::GNU PARALLEL::::::::::::::::::::

#TODO

#::::::::::::::::::::Unlimited Threads::::::::::::::::::::
#!/bin/bash

PID=$$
cleanup()
{
  rm /dev/shm/${PID}.* 2>/dev/null
  kill -- -$$
}
trap "cleanup" SIGINT

if [ "$#" -lt 1 ];then
  echo -e "Usage: ${0##*/} [server list] [commands]

  EXAMPLE:
    ${0##*/} machines.txt \"top -n 1 -b | head -n 4 | tail -n 1 | sed 's/,.*//'\" 
"
  exit 1
fi

servers="$1"
shift
param="$@"

services=$(cat $servers 2>/dev/null)

IFS='
'

for server in ${services[@]}
do
  ssh $server -q "$param" > /dev/shm/${PID}.${server} 2>&1 &
done

for job in $(jobs -p)
do
  wait $job
done

for server in ${services[@]}
do
  echo -e "\033[34m$server\033[0m"
  cat /dev/shm/${PID}.${server} | sed "s/^/  /"
  rm /dev/shm/${PID}.${server}
done

#::::::::::::::::::::Limited Threads::::::::::::::::::::

#!/bin/bash

PID=$$
cleanup()
{
  rm /dev/shm/${PID}.* 2>/dev/null
  kill -- -$$
}
trap "cleanup" SIGINT

if [ "$#" -lt 1 ];then
  echo -e "Usage: ${0##*/} [server list] [commands]

  EXAMPLE:
    ${0##*/} machines.txt \"top -n 1 -b | head -n 4 | tail -n 1 | sed 's/,.*//'\" 
"
  exit 1
fi

MAX_THREADS=30
if [ ! -f /dev/shm/max_threads ];then
  echo "$MAX_THREADS" > /dev/shm/max_threads
fi

servers="$1"
shift
param="$@"

services=$(cat $servers 2>/dev/null)

waitany() {
  MAX_THREADS=$(</dev/shm/max_threads)
  echo -e "  checking wait on threads (max: $MAX_THREADS)..."
  while [ 1 ]
  do
    IFS=$'\n' read -rd '' -a processes <<< "$(jobs -p)"
    if [ ${#processes[@]} -lt $MAX_THREADS ];then
      echo -e "  done waiting on ${#processes[@]} < $MAX_THREADS"
      return
    fi
    sleep 1
    MAX_THREADS=$(</dev/shm/max_threads) #update once a second
  done
}

IFS='
'

for server in ${services[@]}
do
  waitany
  #thread &
  ssh $server -q "$param" > /dev/shm/${PID}.${server} 2>&1 &
done

for job in $(jobs -p)
do
  wait $job
done

#Combine results:
for server in ${services[@]}
do
  echo -e "\033[34m$server\033[0m"
  cat /dev/shm/${PID}.${server} | sed "s/^/  /"
  rm /dev/shm/${PID}.${server}
done

#::::::::::::::::::::Split Work::::::::::::::::::::

#!/bin/bash

PID=$$
cleanup()
{
  rm /dev/shm/${PID}.* 2>/dev/null
  kill -- -$$
}
trap "cleanup" SIGINT

MAX_THREADS=30
if [ ! -f /dev/shm/max_threads ];then
  echo "$MAX_THREADS" > /dev/shm/max_threads
fi

WORK=/dev/shm/${PID}.work
SLICE=100
mysql -BNe "
  SELECT
    domain
  FROM domains
" > $WORK
TOTAL=$(wc -l $WORK | cut -d ' ' -f 1)
SLICES=$(seq 0 $SLICE $TOTAL | wc -l)

progress() {
  DONE=$(ls /dev/shm/${PID}.thread.* 2>/dev/null | wc -l)
  printf "\033[33mProgress:\033[0m %6s/%6s @ %6s\r" "$(expr $DONE \* $SLICE)" "$TOTAL" "$(echo $DONE $SLICES | awk '{printf "%.2f%%", $1/$2 * 100}')"
}

waitany() {
  MAX_THREADS=$(</dev/shm/max_threads)
  while [ 1 ]
  do
    IFS=$'\n' read -rd '' -a processes <<< "$(jobs -p)"
    if [ ${#processes[@]} -lt $MAX_THREADS ];then
      return
    fi
    progress
    sleep 1
    MAX_THREADS=$(</dev/shm/max_threads) #update once a second
  done
}

check() {
  response=$(host -t mx $1)
  case $response in
    *"no MX record")
        echo "$1:none"
      ;;
    *"not found"*)
        echo "$1:not found"
      ;;
    *)
        echo "$1:\"$response\""
      ;;
  esac
}

thread() {
  POSITION=$1
  for domain in $(tail -n +$POSITION $WORK | head -n 100)
  do
    part=$domain
    result="$(check $domain)"
    while [ 1 -lt "$(echo "$part" | grep -o '\.' | wc -l)" ]
    do
      part=${part#*.}
      result="$result,$(check $part)"
    done
    #echo -e "\033[32m$domain\033[0m: $result"
    echo $result >> $WORK.$POSITION
  done

  #Done with slice, so mark as complete:
  mv $WORK.$POSITION /dev/shm/${PID}.thread.$POSITION
}

IFS='
'
for work in $(seq 0 $SLICE $TOTAL)
do
  waitany
  thread $work &
done

progress

#finish threads
for job in $(jobs -p)
do
  wait $job
done

progress #should be 100%
echo ""
#finalize:
echo "Finishing..."
cat /dev/shm/${PID}.thread.* > results.csv
echo "DONE: see results.csv"
cleanup


#Clean/concise backgrounding with cleanup traps:
  LOG='/tmp'
  SERVICE_VERSION='0.1'
  REPO='repo.intra.net'

  function check() {
    if [ ${1} -gt 0 ];then
      echo "check returned ${1}"
      if [ -f "${2}" ];then
        cat ${2}
      fi
      exit 1
    fi
  }
  function build() {
    local image=$1
    trap 'test -n "${docker_id}" && echo "Stopping ${image}:${SERVICE_VERSION}" && docker stop ${docker_id}' KILL EXIT

    echo "Building ${image}:${SERVICE_VERSION}"
    DOCKER_BUILDKIT=1 docker build \
      --build-arg SERVICE_VERSION \
      --secret id=password,env=PWD \
      -t ${REPO}/${image}:${SERVICE_VERSION} \
      -f docker/${image}.Dockerfile \
      .
    check $?

    if [ -f ${PWD}/test/${image}.py ];then
      echo "Starting ${image}:${SERVICE_VERSION}"
      local docker_id=$(
        docker run \
          --entrypoint bash \
          -d -it --rm \
          ${REPO}/${image}:${SERVICE_VERSION}
      )

      echo "Testing ${image}:${SERVICE_VERSION}"
      docker run \
        --rm \
        -v ${PWD}/test/util.py:/opt/test/util.py \
        -v ${PWD}/test/${image}.py:/opt/test/test_${image}.py \
        -v /var/run/docker.sock:/var/run/docker.sock:ro \
        testinfra:1.0 \
        --hosts=docker://${docker_id} > ${LOG}/${image}.log
      check $? ${LOG}/${image}.log
    else
      echo "WARN: no tests for container ${image}"
    fi

    echo "Pushing ${REPO}/${image}:${SERVICE_VERSION}"
    docker push ${REPO}/${image}:${SERVICE_VERSION}
    echo "${image}:${SERVICE_VERSION} completed"
  }

  #Dependencies:
  build base
  build node
  build tomcat

  #Analyzers:
  build web &
  build foo &
  build bar &
  build baz &

  echo "waiting..."
  trap 'kill $(jobs -p) 2>/dev/null' EXIT
  for job in $(jobs -p)
  do
    wait $job
    check $?
  done

  echo "Print logs..."
  for log in ${LOG}/*.log
  do
    echo ${log%.log}
    cat ${log} | sed 's/^/  /'
  done

  echo "DONE"
