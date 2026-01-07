# Quality Scenarios

## Registration week — many students open “Current Week Timetable” at 9 AM (Ayat Idayatov)

**Source of Stimulus:** Student  

**Stimulus:** Opens “Current Week Timetable” page repeatedly during registration peak (many users in parallel).  

**Artifact:** University Scheduling System — `timetableViewer` and its dependencies:  
- database  
- courseInfoContainer  

**Environment:** Production, peak load.  

**Response:**  
The Timetable Viewer processes incoming timetable-view requests, retrieves required timetable data (DB/cache), and returns the timetable view to the user; if course details are needed, it requests them from the Course Information Service and renders them without blocking the timetable view unnecessarily.  

**Measure:** 2 seconds for the timetable page response  


---

## University wants to change the login system (Ayat Idayatov)

**Source of Stimulus:** Developer  

**Stimulus:** University changes the Auth/Identity Provider  

**Artifact:** System-level auth integration and containers/components that enforce permissions, e.g.:  
- scheduleModificationContainer.authorizationService  
- role validation inside teacherInfoContainer (Auth/Role Validator)  
- system’s connection to authProvider  

**Environment:** Design-time.  

**Response:**  
Developers update auth integration (configuration/adapter + role mapping), update affected services, then test and deploy the change to staging and production.  

**Measure:** Change implemented + deployed in ≤ 3 developer-days  


---

## Request for adding a new scheduling constraint (Emil Farzaliyev)

**Source of Stimulus:** Developer team  

**Stimulus:**  
A request to introduce a new scheduling constraint (for example, a teacher cannot teach more than four hours per day).  

**Artifact:** Conflict Validator component within Schedule Modification Service  

**Environment:** Design-time — during development, testing, and deployment of a new system version  

**Response:**  
The new scheduling constraint is implemented as an independent rule module and integrated into the Conflict Validator through configuration or a rule registry. Existing validation logic remains unchanged, and the modification workflow continues to operate as before. The change is tested and deployed without affecting other system containers.  

**Measure:**  
At most two existing components are modified (Conflict Validator + config/registry); one new rule module is added.  
Implementation and testing require no more than two developer-days.  


---

## Two committee members try to modify the same course at the same time (Emil Farzaliyev)

**Source of Stimulus:** Scheduling Committee member  

**Stimulus:**  
Two committee members try to modify the same course timeslot/room at nearly the same time (concurrent update).  

**Artifact:** Schedule Modification Service — specifically:  
- Modification Workflow Manager  
- Concurrency Manager  
- Schedule Repository  

**Environment:** Production, during timetable-finalization period.  

**Response:**  
The system saves the first change.  
When the second person tries to save, the system notices the schedule was already changed by someone else, so it does not overwrite it. Instead, it shows a “someone updated this” message and loads the newest schedule so the second person can try again. The event is logged.  

**Measure:**  
- 100% of conflicting concurrent edits are detected and rejected  
- Conflict response returned within ≤ 2 seconds  


---

## Performance — Response Time under Peak Load (Ivan Tregub)

**Source of Stimulus:** Students  

**Stimulus:**  
At the beginning of the semester, many students simultaneously search for courses and view their schedules.  

**Artifact:**  
- `timetableViewer` (Timetable Viewer)  
- `courseInfoContainer` (Course Information Service)  
- `redisCache` (Redis Cache)  
- `database` (Main Database — RDS Primary + RDS Read Replica)  
- `loadBalancer` (Load Balancer — Nginx / AWS ALB)  

**Environment:** Production, peak-load period (start of semester), normal operation.  

**Response:**  
The system handles concurrent read requests by scaling service instances across availability zones and routing API traffic via the Load Balancer (AWS ALB). Course search and course details are served by the Course Information Service, using the Redis Cache for frequently accessed data and the database read replica for read-heavy workloads, so that responses remain fast for users.  

**Measure:** ≥ 95% of requests respond within 2 seconds  


---

## Performance — First day of semester: traffic spikes to 5,000 concurrent students accessing “Timetable Viewer” (Adriana González Nieves)

**Source of Stimulus:** Student  

**Stimulus:**  
5,000 concurrent users attempt to view their timetables simultaneously at 9:00 AM on the first day of the semester.  

**Artifact:**  
- `universitySchedulingSystem.timetableViewer`  
- `universitySchedulingSystem.loadBalancer` (new)  
- backend services (`courseInfoContainer`, `teacherInfoContainer`)  

**Environment:** Production, peak load, high concurrency.  

**Response:**  
The `loadBalancer` intercepts the massive influx of requests from the `timetableViewer` (UI) and distributes them across multiple backend service instances using a round-robin strategy. This prevents any single service instance from becoming a bottleneck and crashing.  

**Measure:** Average page load time remains under 2 seconds with 0% error rate (no timeouts)  


---

## Modifiability — Ease of Feature Extension (Schedule Export) (Ivan Tregub)

**Source of Stimulus:** University administration / product owner  

**Stimulus:** Add a feature to export student schedules to Google Calendar / iCal.  

**Artifact:**  
- `timetableViewer` (Timetable Viewer)  
- `loadBalancer` (Nginx / AWS ALB)  
- `calendarIntegrationService` (new)  
- `scheduleModificationContainer` (Schedule Modification Service)  
- `externalCalendar` (External Calendar System)  

**Environment:** Production, normal operation.  

**Response:**  
The Timetable Viewer sends an export request via the Load Balancer. The Calendar Integration Service fetches schedule data from the Schedule Modification Service (REST/JSON) and creates/updates events in the External Calendar System.  

**Measure:** Feature added by introducing a new service; existing services remain unchanged (no regression).  


---

## C4 Model updates for Schedule Export (Ivan Tregub)

- **Container level:** A new container `calendarIntegrationService` was added to the model (reflected in the Container View).  
- **Relationships:** New relationships were introduced:  
  - `loadBalancer` → `calendarIntegrationService`  
  - `calendarIntegrationService` → `scheduleModificationContainer`  
  - `calendarIntegrationService` → `externalCalendar`  
  These changes are reflected in the System Context View and the Container View.  
- **Deployment:** The new service was added as a container instance in Development and deployed in two availability zones in Production (reflected in Deployment Views).  
- **Dynamic view:** A new dynamic view documents the runtime interaction when a student exports a schedule to an external calendar.  


---

## Availability — Database hardware failure during critical schedule modification period (Scenario 2)

**Source of Stimulus:** Database infrastructure (hardware failure)  

**Stimulus:**  
During the critical schedule modification period, the primary database server suffers a hardware failure.  

**Artifact:**  
- `database` (PostgreSQL primary) and a standby/failover database instance  
- all services that depend on the database for creation/modification/viewing (e.g., `scheduleModificationContainer`, `timetableViewer`)  

**Environment:** Production, critical schedule modification period, primary database hardware failure.  

**Response:**  
The system automatically fails over from the primary database to a standby database instance and re-establishes connections so students can continue modifying schedules without service interruption.  

**Measure:** Failover completed within ≤ 30 seconds; schedule modification continues without observable downtime.  


---

## C4 Model implications for Database Failover (Scenario 2)

- **Current state:** Deployment diagram shows a single `Database` container (PostgreSQL).  
- **Issue:** This is a Single Point of Failure (SPOF): if the unique database node fails, all services stop working immediately.  
- **Extension needed:** Update the Deployment View to include:  
  - a standby/failover database instance (for automatic promotion)  
  - a database read replica (slave) for resilience/read scaling (if applicable)  
  - a failover mechanism (health checks + automatic rerouting) so the system survives a database crash.  
