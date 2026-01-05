workspace "Exam Management System (EXA)" "Architecture model of the Exam Management System for exam terms, registration, grading, and viewing results." {

  model {

    // People
    student = person "Student" "Views exam terms, registers for exams and views results."
    teacher = person "Teacher" "Creates exam terms, awards grades and views results."
    admin = person "Administrator" "Oversees the system and exam configuration."

    // External systems
    sis = softwareSystem "Student Information System (SIS)" "Central academic system with courses, enrolments and final grades."
    timetable = softwareSystem "Timetable Service" "Provides timetable and room occupancy information."
    notification_gateway = softwareSystem "Notification Gateway" "Institutional e-mail/SMS gateway."
    identity_provider = softwareSystem "Identity Provider (IdP)" "Provides single sign-on authentication."

    // Exam Management System
    exa = softwareSystem "Exam Management System (EXA)" "Supports exam term management, registration, grading and result viewing." {

      // Containers
      web_app = container "Web Application" "Web UI for students and teachers (dashboards, exam terms, grades, results)." "Web SPA" {

        // Web application components
        ui_shell = component "Web UI Shell" "Layout, navigation, authentication shell and common UI elements." "Component"
        ui_terms = component "Exam Term Views" "Pages for browsing and filtering exam terms." "Component"
        ui_registration = component "Registration Views" "Pages for registering/deregistering exams and showing capacities." "Component"
        ui_grading = component "Grading Views" "Teacher views for entering and editing grades." "Component"
        ui_results = component "Results Views" "Students' result/grade overview and history." "Component"
      }

      api = container "Backend API" "Backend service implementing exam terms, registration, grading and results." "Application Service" {

        // Backend components (inside Backend API)
        term_management = component "Exam Term Management" "Create/edit/cancel exam terms and reserve rooms; handle conflicts and post-exam locking." "Component"
        registration = component "Registration Management" "Register/deregister students; enforce eligibility, capacity and time-conflict rules." "Component"
        grading = component "Grading Management" "Enter, validate, finalise and adjust grades." "Component"
        results = component "Result Viewing" "Provide result dashboard, detail views and basic exports." "Component"
        notification = component "Notification Service" "Prepare and trigger notifications for terms, registrations and grades." "Component"
        integration = component "Integration Adapter" "Integrate with SIS and timetable for data and conflicts." "Component"
        persistence = component "Persistence Adapter" "Central data access for exam terms, registrations, grades and results." "Component"
      }

      db = container "Database" "Stores exam terms, registrations, grades, rooms and results." "Relational Database"
    }

    // System-level relationships
    student -> exa "Uses for exam registration and viewing results."
    teacher -> exa "Uses for exam term management and grading."
    admin -> exa "Uses for configuration and reporting."

    exa -> sis "Reads course/enrolment data; writes final grades." "REST / batch"
    exa -> timetable "Reads timetable and room occupancy." "REST"
    exa -> notification_gateway "Sends e-mail/SMS notifications." "SMTP / HTTPS"
    exa -> identity_provider "Uses SSO for authentication." "OIDC"

    // Container-level relationships
    student -> web_app "Uses via web browser." "HTTPS"
    teacher -> web_app "Uses via web browser." "HTTPS"
    admin -> web_app "Uses via web browser." "HTTPS"

    web_app -> api "Calls backend services." "HTTPS / JSON"
    api -> db  "Reads/writes exam terms, registrations, grades and results." "JDBC / SQL"

    api -> sis "Reads course/enrolment data; writes final grades." "REST / batch"
    api -> timetable "Reads timetable and room availability." "REST"
    api -> notification_gateway "Sends notifications." "SMTP / HTTPS"
    web_app -> identity_provider "Delegates authentication." "OIDC"

    // Component-level relationships (backend)
    web_app -> term_management "Sends commands to create/edit/cancel exam terms and room reservations." "REST / JSON"
    web_app -> registration "Sends register/deregister requests." "REST / JSON"
    web_app -> grading "Sends grade entry and edit requests." "REST / JSON"
    web_app -> results "Requests result overviews and details." "REST / JSON"

    term_management -> integration "Retrieves course/teacher data and room/timetable information." ""
    registration -> integration "Verifies enrolment, eligibility and timetable conflicts." ""
    grading -> integration "Synchronises final grades with SIS." ""
    results -> integration "Fetches historic data for result views." ""

    // all domain logic uses Persistence Adapter for DB access
    term_management -> persistence "Stores and reads exam terms and room reservations." ""
    registration -> persistence "Stores and reads registrations and capacity counters." ""
    grading -> persistence "Stores and reads grades and attendance records." ""
    results -> persistence "Reads grades and exam history for result views and exports." ""

    persistence -> db "Reads/writes exam terms, registrations, grades and results." "SQL"

    // integration with external systems (for dynamic views etc.)
    integration -> sis "Reads course/enrolment data and writes final grades." "REST / batch"
    integration -> timetable "Reads timetable and room availability." "REST"

    registration -> notification "Triggers notifications about registration and cancellation." ""
    term_management -> notification "Triggers notifications about exam term create/update/cancel." ""
    grading -> notification "Triggers notifications about grade publication or changes." ""

    notification -> notification_gateway "Delivers notification messages to users." ""

    // Component-level relationships (web app <-> backend components)
    ui_terms -> term_management "Uses term management APIs." "REST / JSON"
    ui_registration -> registration "Uses registration APIs." "REST / JSON"
    ui_grading -> grading "Uses grading APIs." "REST / JSON"
    ui_results -> results "Uses result query APIs." "REST / JSON"
    ui_shell -> notification "Triggers user notifications (e.g. banners/toasts)." "REST / JSON"
    ui_shell -> identity_provider "Coordinates login/logout via SSO." "OIDC"

    // -------------------------------------------------
    // Deployment environments
    // -------------------------------------------------

    // Development / testing environment
    deploymentEnvironment "Development" {

      deploymentNode "Developer Laptop / Test Server" "Local development machine or shared test server." "Workstation / Test VM" {
        web_app_dev = containerInstance web_app
        api_dev = containerInstance api
        db_dev = containerInstance db
      }

      deploymentNode "External Systems (Test)" "Test/staging instances of external systems." "External / Test" {
        sis_test = softwareSystemInstance sis
        timetable_test = softwareSystemInstance timetable
        notif_test = softwareSystemInstance notification_gateway
        idp_test = softwareSystemInstance identity_provider
      }
    }

    // Production environment
    deploymentEnvironment "Production" {

      deploymentNode "User Devices" "Student, teacher and admin browsers." "Browser" {
        web_app_prod = containerInstance web_app
      }

      deploymentNode "Institution Data Center" "On-prem or cloud environment for EXA." "Data Center" {

        deploymentNode "EXA Application Server" "Runs EXA Backend API." "Application Server" {
          api_prod = containerInstance api
        }

        deploymentNode "EXA Database Server" "Runs relational database for EXA." "Database Server" {
          db_prod = containerInstance db
        }
      }

      deploymentNode "External Systems" "Existing institutional systems (production)." "External" {
        sis_prod = softwareSystemInstance sis
        timetable_prod = softwareSystemInstance timetable
        notif_prod = softwareSystemInstance notification_gateway
        idp_prod = softwareSystemInstance identity_provider
      }
    }
  }

  views {

    // L1: System context
    systemContext exa "EXA-SystemContext" "System context of the Exam Management System." {
      include *
      autoLayout
    }

    // L2: Containers
    container exa "EXA-Containers" "Container view of the Exam Management System." {
      include *
      autoLayout
    }

    // L3: Components of Backend API
    component api "EXA-API-Components" "Major backend components of the EXA Backend API." {
      include *
      autoLayout
    }

    // L3: Components of Web Application
    component web_app "EXA-WebApp-Components" "Major UI components of the EXA Web Application." {
      include *
      autoLayout
    }

    // ==============================
    // Dynamic View 1 – Exam Term Management
    // ==============================
    dynamic api "EXA-DYN-ExamTermManagement" "Teacher creates/edits exam term and reserves a room." {

      web_app -> term_management "Create/edit term"

      term_management -> integration "Load course & teacher data"
      integration -> sis "Request data"
      sis -> integration "Return data"
      integration -> term_management "Return SIS data"

      term_management -> integration "Search rooms"
      integration -> timetable "Request room availability"
      timetable -> integration "Available rooms"
      integration -> term_management "Return room data"

      term_management -> persistence "Store exam term & reservation"
      persistence -> db "Store exam term & reservation"

      term_management -> notification "Trigger notifications"
      notification -> notification_gateway "Send SMS/e-mail"

      autoLayout lr
    }

    // ==============================
    // Dynamic View 2 – Registration Flow
    // ==============================
    dynamic api "EXA-DYN-ExamRegistration" "Student registers or deregisters for an exam term." {

      web_app -> registration "Begin registration"

      registration -> integration "Validate enrolment"
      integration -> sis "Check SIS eligibility"
      sis -> integration "Eligibility result"
      integration -> registration "Return validation"

      registration -> persistence "Store registration update"
      persistence -> db "Store registration update"

      registration -> notification "Trigger confirmation"
      notification -> notification_gateway "Send confirmation"

      autoLayout lr
    }

    // ==============================
    // Dynamic View 3 – Grading Flow
    // ==============================
    dynamic api "EXA-DYN-Grading" "Teacher enters, finalises and publishes grades." {

      web_app -> grading "Open grading screen / submit grades"

      grading -> persistence "Load registrations and existing grades"
      persistence -> db "Read registrations and grades"

      grading -> persistence "Store updated grades"
      persistence -> db "Write updated grades"

      grading -> integration "Synchronise final grades with SIS"
      integration -> sis "Send final grades"
      sis -> integration "Acknowledgement"
      integration -> grading "Sync status"

      grading -> notification "Trigger grade publication notification"
      notification -> notification_gateway "Send SMS/e-mail about new grades"

      autoLayout lr
    }

    // ==============================
    // Dynamic View 4 – Result Viewing
    // ==============================
    dynamic api "EXA-DYN-ResultViewing" "Student views exam results and grade history." {

      web_app -> results "Open results dashboard"

      results -> persistence "Query recent results and exam history"
      persistence -> db "Read grades and exam history"

      results -> integration "Request historic data (if needed)"
      integration -> sis "Fetch historic grades"
      sis -> integration "Return historic data"
      integration -> results "Return SIS history"

      autoLayout lr
    }

    // L4: Deployment – Development/Testing
    deployment exa "Development" "EXA-Deployment-Dev" "Development/testing deployment of EXA." {
      include *
      autoLayout
    }

    // L4: Deployment – Production
    deployment exa "Production" "EXA-Deployment-Prod" "Production deployment of EXA." {
      include *
      autoLayout
    }

    styles {
      element "Person" {
        shape person
      }
      element "Software System" {
        background #1168bd
        color #ffffff
      }
      element "Container" {
        background #438dd5
        color #ffffff
      }
      element "Component" {
        background #85bbf0
        color #000000
      }
    }

    theme default
  }

}
