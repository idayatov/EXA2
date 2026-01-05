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

**Artifact:**  
Schedule Modification Service — specifically  
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
# (Ivan Tregub)
## Quality Attribute: Performance — Response Time under Peak Load

**Source of Stimulus:** Students (external users)  

**Stimulus:**  
At the beginning of the semester, many students simultaneously search for courses and view their schedules.  

**Artifact:**  
- timetableViewer (Timetable Viewer)  
- courseInfoContainer (Course Information Service)  
- database (RDS Primary + Read Replica)  
- application load balancer  

**Environment:** Production, peak-load period (start of semester), normal operation.  

**Response:**  
The system processes concurrent read requests by distributing traffic across multiple service instances via the Application Load Balancer. Course and timetable read operations are served by the Course Information Service, using database read replicas and cache where available, so that requests are returned without noticeable slowdown for users.  

**Measure:** ≥ 95% of requests respond within 2 seconds
