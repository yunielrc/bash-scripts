load ~/.usr/lib/test_helper.bash

export SWEET_NAUTA_HOST=localhost
export SWEET_NAUTA_PORT=4500
export NAUTA_LOGIN_HOST='secure.etecsa.net'
export INTRANET_HOST='cloud.cd.etecsa.cu'

reconnect-nauta() {
  ../reconnect-nauta "$@"
}

@test 'should exit with success when there is not opened session' {
  curl() { echo false; }
  export -f curl

  run reconnect-nauta

  assert_success
  assert_output ''
}

@test 'should exit with failure when there is an opened session but nauta login host is not reachable' {
  curl() { echo true; }
  ping() { return 1; }
  export -f curl
  export -f ping

  run reconnect-nauta

  assert_failure
  assert_output "There is an opened nauta session, but ${NAUTA_LOGIN_HOST} isn't reachable"
}

@test 'should exit with success when there is an opened session and nauta login host and intranet host are both reachable' {
  curl() { echo true; }
  ping() { return 0; }
  export -f curl
  export -f ping

  run reconnect-nauta

  assert_success
  assert_output ''
}

@test 'should exit with failure when there is an opened session, nauta login host is reachable and disconnection fail' {
  curl() {
    case "$*" in
      */isconnected)
        echo true
      ;;
      */disconnect/*)
        echo '{ "code": "DISCONNECT_FAIL", "message": "disconnect fail" }'
      ;;
      *)
        echo "NONE"
      ;;
    esac
  }
  ping() {
    case "$*" in
      *"$NAUTA_LOGIN_HOST")
        return 0
      ;;
      *"$INTRANET_HOST")
        return 1
      ;;
      *)
        echo "NONE"
      ;;
    esac
  }
  notify-send() { echo ; }
  export -f curl
  export -f ping
  export -f notify-send

  run reconnect-nauta

  assert_failure
  assert_output "There is an opened nauta session, but ${INTRANET_HOST} isn't reachable
Reconnecting nauta session

DISCONNECT_FAIL  disconnect fail"
}

@test 'should exit with failure when there is an opened session, nauta login host is reachable, disconnection success and connection fail' {
  curl() {
    case "$*" in
      */isconnected)
        echo true
      ;;
      */disconnect/*)
        echo '{ "code": "DISCONNECT_SUCCESS", "message": "disconnect success" }'
      ;;
      */connect/*)
        echo '{ "code": "CONNECT_FAIL", "message": "connect fail" }'
      ;;
      *)
        echo "NONE"
      ;;
    esac
  }
  ping() {
    case "$*" in
      *"$NAUTA_LOGIN_HOST")
        return 0
      ;;
      *"$INTRANET_HOST")
        return 1
      ;;
      *)
        echo "NONE"
      ;;
    esac
  }
  notify-send() { echo ; }
  export -f curl
  export -f ping
  export -f notify-send

  run reconnect-nauta

  assert_failure
  assert_output "There is an opened nauta session, but ${INTRANET_HOST} isn't reachable
Reconnecting nauta session

DISCONNECT_SUCCESS  disconnect success

CONNECT_FAIL  connect fail"
}

@test 'should exit with success when there is an opened session, nauta login host is reachable, disconnection success and connection success' {
  curl() {
    case "$*" in
      */isconnected)
        echo true
      ;;
      */disconnect/*)
        echo '{ "code": "DISCONNECT_SUCCESS", "message": "disconnect success" }'
      ;;
      */connect/*)
        echo '{ "code": "CONNECT_SUCCESS", "message": "connect success" }'
      ;;
      *)
        echo "NONE"
      ;;
    esac
  }
  ping() {
    case "$*" in
      *"$NAUTA_LOGIN_HOST")
        return 0
      ;;
      *"$INTRANET_HOST")
        return 1
      ;;
      *)
        echo "NONE"
      ;;
    esac
  }
  notify-send() { echo ; }
  export -f curl
  export -f ping
  export -f notify-send

  run reconnect-nauta

  assert_success
  assert_output "There is an opened nauta session, but ${INTRANET_HOST} isn't reachable
Reconnecting nauta session

DISCONNECT_SUCCESS  disconnect success

CONNECT_SUCCESS  connect success"
}
