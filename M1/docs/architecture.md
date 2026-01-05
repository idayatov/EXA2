# Exam Management System (EXA) – Architecture Documentation

This document describes the architecture of the Exam Management System

---

## 1. System Context (L1)

The EXA system is used by three main user groups:

- **Student** – views terms, registers for exams, views results.
- **Teacher** – creates terms, grades students, manages exam data.
- **Administrator** – oversees configuration and reporting.

External systems:

- **Student Information System (SIS)** – enrolments, course catalog, final grade sync.
- **Timetable Service** – room availability and timetable conflicts.
- **Notification Gateway** – e-mails/SMS notifications.
- **Identity Provider (IdP)** – single sign-on authentication.

**EXA provides:**  
Exam term management, registration, grading, results browsing.

---

## 2. Container Architecture (L2)

EXA consists of three containers:

### **Web Application (SPA)**
- Runs in the browser.
- UI for students, teachers, and admins.
- Handles navigation, SSO login, term browsing, registration actions, grade entry, and results.

### **Backend API**
- Main application service implementing domain logic.
- Modules:
  - Term Management  
  - Registration  
  - Grading  
  - Result Viewing  
  - Notification Service  
  - Integration Adapter  
  - Persistence Adapter  
- Communicates with DB and external systems.

### **Database**
- Relational storage for exam terms, registrations, grades, rooms, and results.

**Container interactions:**
- Web App → Backend API (HTTPS/JSON)
- Backend API → DB (SQL)
- Backend API → SIS / Timetable / Notification Gateway (REST / SMTP)
- Web App → IdP (OIDC)

---

## 3. Backend Components (L3)

### **Exam Term Management**
Creates, edits, cancels exam terms. Handles room reservation and conflict checking.

### **Registration Management**
Registers/deregisters students. Applies eligibility rules, deadlines, and capacity limits.

### **Grading Management**
Supports grade entry, validation, finalisation, editing, and SIS sync.

### **Result Viewing**
Provides dashboards and detail views for student results and grade history.

### **Notification Service**
Constructs notifications for term updates, registration events, and grade publications.

### **Integration Adapter**
Talks to SIS and the Timetable Service for enrolment data and room availability.

### **Persistence Adapter**
Central data access layer for exam terms, registrations, grades, and results.

---

## 4. Web Application Components (L3)

- **UI Shell** – layout, navigation, authentication.
- **Exam Term Views** – browsing/filtering exam terms.
- **Registration Views** – register/deregister flows.
- **Grading Views** – teacher grade entry.
- **Results Views** – student result dashboard.

---

## 5. Deployment View (L4)

### **Development Environment**
- Developer laptop / test server running:
  - Web App
  - Backend API
  - Local/Test DB  
- Connected to staging SIS, Timetable, Notification Gateway, and IdP.

### **Production Environment**
- **User Devices** – browser running EXA Web App.
- **Institution Data Center**
  - Application Server running Backend API
  - Database Server running relational DB
- **External Systems**
  - Production SIS, Timetable, Notification Gateway, IdP.

---

## 6. Main Dynamic Flows

### **Exam Term Management (Teacher)**
1. Teacher creates/edits term in Web App  
2. Backend loads course info from SIS  
3. Backend queries Timetable for rooms  
4. Backend stores term & reservation  
5. Backend triggers notifications

### **Registration (Student)**
1. Student clicks Register  
2. Backend validates eligibility via SIS  
3. Backend writes registration  
4. Student receives confirmation notification

### **Grading**
1. Teacher enters grades  
2. Backend persists changes  
3. Backend synchronises final grades with SIS  
4. Notifications sent to students

### **Result Viewing**
1. Student opens results  
2. Backend loads grades/history  
3. Backend optionally fetches historic SIS data  
4. Results displayed

---

## 7. Styles / Conventions

- Domain logic only in Backend API components.
- UI contains no business rules.
- Persistence Adapter is the single point of DB access.
- Integration Adapter isolates all external-system communication.

---

## 8. Summary

The EXA architecture follows the C4 model with a clear separation between UI, backend domain logic, and infrastructure.  
The system integrates with existing university services and provides a structured workflow for exam terms, registrations, grading, and result viewing.
