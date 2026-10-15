
package com.fleet.servlet;

import com.fleet.dao.VehicleDAO;
import com.fleet.model.Vehicle;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @SuppressWarnings("unchecked")
    private List<String> sessionList(HttpSession session, String key) {
        Object value = session.getAttribute(key);

        if (value instanceof List<?>) {
            return (List<String>) value;
        }

        List<String> list = new ArrayList<>();
        session.setAttribute(key, list);
        return list;
    }

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse res)
            throws ServletException, IOException {

        String page = req.getParameter("page");

        if (page == null || page.isBlank()) {
            page = "overview";
        }

        if (!List.of("overview", "vehicles", "routes",
                "maintenance", "alerts").contains(page)) {
            page = "overview";
        }

        req.setAttribute("page", page);

        List<Vehicle> vehicles;

        try {
            vehicles = new VehicleDAO().findAll();
            req.setAttribute("source", "MySQL database");
        } catch (SQLException e) {
            vehicles = List.of(
                new Vehicle("AV-001", "ACTIVE", 82, "Normal", "Sector 62, Noida"),
                new Vehicle("AV-002", "ACTIVE", 46, "Normal", "Electronic City, Noida"),
                new Vehicle("AV-003", "IDLE", 91, "Normal", "Fleet Depot"),
                new Vehicle("AV-004", "WARNING", 18, "Low battery", "Sector 18, Noida"),
                new Vehicle("AV-005", "MAINTENANCE", 54, "Sensor issue", "Service Centre")
            );
            req.setAttribute("source", "Sample data — database unavailable");
            getServletContext().log("Unable to read vehicle data", e);
        }

        req.setAttribute("vehicles", vehicles);

        int active = 0;
        int lowBattery = 0;
        int maintenance = 0;
        List<String> alerts = new ArrayList<>();

        for (Vehicle v : vehicles) {
            if ("ACTIVE".equalsIgnoreCase(v.getStatus())) {
                active++;
            }

            if (v.getBattery() <= 20) {
                lowBattery++;
                alerts.add(v.getCode() + ": Low battery (" +
                           v.getBattery() + "%)");
            }

            if ("MAINTENANCE".equalsIgnoreCase(v.getStatus())) {
                maintenance++;
                alerts.add(v.getCode() + ": Maintenance required");
            }

            if ("WARNING".equalsIgnoreCase(v.getStatus())) {
                alerts.add(v.getCode() + ": " + v.getHealth());
            }
        }

        req.setAttribute("activeCount", active);
        req.setAttribute("lowBatteryCount", lowBattery);
        req.setAttribute("maintenanceCount", maintenance);
        req.setAttribute("alerts", alerts);

        HttpSession session = req.getSession();
        req.setAttribute("routes", sessionList(session, "routes"));
        req.setAttribute("maintenanceTasks",
                         sessionList(session, "maintenanceTasks"));

        req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp")
           .forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        HttpSession session = req.getSession();

        if ("addRoute".equals(action)) {
            String route = req.getParameter("routeName");

            if (route != null && !route.isBlank()) {
                sessionList(session, "routes").add(route.trim());
                session.setAttribute("notice", "Route added successfully.");
            }
            res.sendRedirect(req.getContextPath() + "/dashboard?page=routes");
            return;
        }

        if ("addMaintenance".equals(action)) {
            String task = req.getParameter("task");

            if (task != null && !task.isBlank()) {
                sessionList(session, "maintenanceTasks").add(task.trim());
                session.setAttribute("notice", "Maintenance task scheduled.");
            }
            res.sendRedirect(req.getContextPath() + "/dashboard?page=maintenance");
            return;
        }

        if ("vehicleCommand".equals(action)) {
            String vehicle = req.getParameter("vehicleCode");
            String command = req.getParameter("command");

            if (vehicle != null &&
                vehicle.matches("AV-[A-Za-z0-9-]+") &&
                List.of("STATUS_CHECK", "RETURN_TO_DEPOT",
                        "PAUSE_TRIP").contains(command)) {

                session.setAttribute("notice",
                    "Demo command accepted for " + vehicle +
                    ": " + command + ". No real vehicle was controlled.");
            } else {
                session.setAttribute("notice", "Invalid demo command.");
            }

            res.sendRedirect(req.getContextPath() + "/dashboard?page=vehicles");
            return;
        }

        res.sendRedirect(req.getContextPath() + "/dashboard");
    }
}