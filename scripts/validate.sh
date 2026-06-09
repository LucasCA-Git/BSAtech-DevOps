#!/bin/sh

FAIL=0

check() {
  local name=$1
  local url=$2
  local expected=$3
  local insecure=$4

  if [ "$insecure" = "true" ]; then
    body=$(curl -sk --max-time 5 "$url" 2>/dev/null || true)
    code=$(curl -sk --max-time 5 -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || echo "000")
  else
    body=$(curl -s --max-time 5 "$url" 2>/dev/null || true)
    code=$(curl -s --max-time 5 -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || echo "000")
  fi

  if [ -n "$expected" ]; then
    echo "$body" | grep -q "$expected" 2>/dev/null && result="PASS" || result="FAIL"
  else
    { [ "$code" -ge 200 ] && [ "$code" -lt 400 ]; } 2>/dev/null && result="PASS" || result="FAIL"
  fi

  printf "%-40s %s\n" "$name" "$result"
  [ "$result" = "FAIL" ] && FAIL=$((FAIL + 1)) || true
}

check "HTTPS"            "https://localhost"                "."    "true"
check "HTTP redirect"    "http://localhost"                 ""     "false"
check "Prometheus"       "http://localhost:9090/-/ready"    "Ready"    "false"
check "Grafana"          "http://localhost:3000/api/health" "database" "false"
check "Node Exporter"    "http://localhost:9100/metrics"    "node_" "false"
check "cAdvisor"         "http://localhost:8080/metrics"    "container_" "false"
check "MySQL Exporter"   "http://localhost:9104/metrics"    "mysql_" "false"
check "Nginx Exporter"   "http://localhost:9113/metrics"    "nginx_" "false"

echo ""
[ "$FAIL" -eq 0 ] && echo "All checks passed." || echo "$FAIL check(s) failed."
exit $FAIL