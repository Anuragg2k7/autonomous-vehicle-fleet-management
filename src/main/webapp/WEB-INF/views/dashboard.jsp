
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>AV Fleet Management</title>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<aside>
    <h2>AV<span>FLEET</span></h2>
    <p class="workspace">FLEET WORKSPACE</p>


<nav class="sidebar-nav">
    <a href="${pageContext.request.contextPath}/dashboard?page=overview">▦ Overview</a>
    <a href="${pageContext.request.contextPath}/dashboard?page=vehicles">◈ Vehicles</a>
    <a href="${pageContext.request.contextPath}/dashboard?page=routes">⌁ Routes</a>
    <a href="${pageContext.request.contextPath}/dashboard?page=maintenance">⚙ Maintenance</a>
    <a href="${pageContext.request.contextPath}/dashboard?page=alerts">♧ Alerts</a>
</nav>

    <footer>
        Fleet Manager<br>
        <small>Student demo workspace</small>
    </footer>
</aside>

<main>
    <header>
        <div>
            <small>FLEET OPERATIONS / <c:out value="${page}"/></small>
            <h1>
                <c:choose>
                    <c:when test="${page == 'vehicles'}">Vehicle Management</c:when>
                    <c:when test="${page == 'routes'}">Route Planning</c:when>
                    <c:when test="${page == 'maintenance'}">Maintenance Centre</c:when>
                    <c:when test="${page == 'alerts'}">Fleet Alerts</c:when>
                    <c:otherwise>Fleet Dashboard</c:otherwise>
                </c:choose>
            </h1>
            <p>Monitor vehicle health and fleet operations.</p>
        </div>
        <label>● Demo system</label>
    </header>

    <c:if test="${not empty notice}">
        <div class="notice">
            <c:out value="${notice}"/>
        </div>
        <c:remove var="notice" scope="session"/>
    </c:if>

    <c:if test="${page == 'overview'}">
        <section class="stats">
            <article>Total vehicles
                <strong>${vehicles.size()}</strong>
                <small>Registered vehicles</small>
            </article>
            <article>Active vehicles
                <strong class="green">${activeCount}</strong>
                <small>Currently operational</small>
            </article>
            <article>Low battery
                <strong class="amber">${lowBatteryCount}</strong>
                <small>Battery at or below 20%</small>
            </article>
            <article>Maintenance
                <strong class="red">${maintenanceCount}</strong>
                <small>Service required</small>
            </article>
        </section>
    </c:if>

    <c:if test="${page == 'overview' || page == 'vehicles'}">
        <section class="panel">
            <h3>Vehicle status</h3>
            <p>Data source: <c:out value="${source}"/></p>
            <div class="scroll">
                <table>
                    <thead>
                    <tr>
                        <th>VEHICLE</th><th>STATUS</th>
                        <th>BATTERY</th><th>HEALTH</th><th>LOCATION</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="v" items="${vehicles}">
                        <tr>
                            <td><b><c:out value="${v.code}"/></b></td>
                            <td><span class="tag"><c:out value="${v.status}"/></span></td>
                            <td><c:out value="${v.battery}"/>%</td>
                            <td><c:out value="${v.health}"/></td>
                            <td><c:out value="${v.location}"/></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </section>
    </c:if>

    <c:if test="${page == 'vehicles'}">
        <section class="panel extra-panel">
            <h3>Vehicle command simulator</h3>
            <p>Demo only — this does not control a real vehicle.</p>
            <form method="post"
                  action="${pageContext.request.contextPath}/dashboard">
                <input type="hidden" name="action" value="vehicleCommand">
                <label for="vehicleCode">Select vehicle</label>
                <select id="vehicleCode" name="vehicleCode" required>
                    <c:forEach var="v" items="${vehicles}">
                        <option value="${v.code}"><c:out value="${v.code}"/></option>
                    </c:forEach>
                </select>
                <label for="command">Demo command</label>
                <select id="command" name="command" required>
                    <option value="STATUS_CHECK">Check status</option>
                    <option value="RETURN_TO_DEPOT">Return to depot (demo)</option>
                    <option value="PAUSE_TRIP">Pause trip (demo)</option>
                </select>
                <button type="submit">Submit demo command</button>
            </form>
        </section>
    </c:if>

    <c:if test="${page == 'routes'}">
        <section class="panel">
            <h3>Route planning</h3>
            <p>Add a route to the demo planning list.</p>
            <form method="post"
                  action="${pageContext.request.contextPath}/dashboard">
                <input type="hidden" name="action" value="addRoute">
                <label for="routeName">Route name or destination</label>
                <input id="routeName" name="routeName"
                       placeholder="e.g. Depot to Sector 62" required>
                <button type="submit">Add route</button>
            </form>
            <h3>Planned routes</h3>
            <ul class="item-list">
                <c:forEach var="route" items="${routes}">
                    <li><c:out value="${route}"/></li>
                </c:forEach>
            </ul>
        </section>
    </c:if>

    <c:if test="${page == 'maintenance'}">
        <section class="panel">
            <h3>Maintenance scheduling</h3>
            <p>Add a maintenance task to the demo list.</p>
            <form method="post"
                  action="${pageContext.request.contextPath}/dashboard">
                <input type="hidden" name="action" value="addMaintenance">
                <label for="task">Vehicle and maintenance task</label>
                <input id="task" name="task"
                       placeholder="e.g. AV-001 - Battery inspection" required>
                <button type="submit">Schedule maintenance</button>
            </form>
            <h3>Maintenance tasks</h3>
            <ul class="item-list">
                <c:forEach var="task" items="${maintenanceTasks}">
                    <li><c:out value="${task}"/></li>
                </c:forEach>
            </ul>
        </section>
    </c:if>

    <c:if test="${page == 'alerts'}">
        <section class="panel">
            <h3>Vehicle alerts</h3>
            <p>Alerts generated from available vehicle status data.</p>
            <c:choose>
                <c:when test="${empty alerts}">
                    <p class="green">No current alerts detected.</p>
                </c:when>
                <c:otherwise>
                    <ul class="item-list">
                        <c:forEach var="alert" items="${alerts}">
                            <li class="alert-item"><c:out value="${alert}"/></li>
                        </c:forEach>
                    </ul>
                </c:otherwise>
            </c:choose>
        </section>
    </c:if>

    <small class="note">
        Academic prototype · Routes and commands are simulated.
    </small>
</main>
</body>
</html>