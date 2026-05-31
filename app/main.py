import random
import time
from fastapi import FastAPI
from prometheus_client import Counter, Gauge, generate_latest, REGISTRY
from starlette.responses import Response

app = FastAPI(title="GridSensor Simulator", version="1.0.0")

# Prometheus metrics
REQUEST_COUNT = Counter('http_requests_total', 'Total HTTP requests', ['method', 'endpoint'])
VOLTAGE_GAUGE = Gauge('substation_voltage_volts', 'Simulated voltage')
CURRENT_GAUGE = Gauge('substation_current_amps', 'Simulated current')
TEMPERATURE_GAUGE = Gauge('substation_temperature_celsius', 'Simulated temperature')
STATUS_GAUGE = Gauge('substation_status', 'Operational status (1=OK, 0=FAULT)')

def simulate_readings():
    """Generate realistic substation metrics."""
    voltage = round(random.uniform(225, 235), 1)
    current = round(random.uniform(10, 50), 1)
    temp = round(random.uniform(20, 80), 1)
    status = 1 if random.random() > 0.05 else 0   # 5% chance of fault
    return voltage, current, temp, status

@app.get("/health")
def health():
    REQUEST_COUNT.labels(method='GET', endpoint='/health').inc()
    v, c, t, s = simulate_readings()
    # Expose as Prometheus metrics
    VOLTAGE_GAUGE.set(v)
    CURRENT_GAUGE.set(c)
    TEMPERATURE_GAUGE.set(t)
    STATUS_GAUGE.set(s)
    return {
        "voltage": v,
        "current": c,
        "temperature": t,
        "status": "ok" if s == 1 else "fault"
    }

@app.get("/metrics")
def metrics():
    REQUEST_COUNT.labels(method='GET', endpoint='/metrics').inc()
    return Response(content=generate_latest(REGISTRY), media_type="text/plain")