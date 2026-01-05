# Exam Management System

## Core features and responsibilities

### Feature: Exam terms management and room reservation

As a teacher, I need to create, edit and cancel exam terms; define exam dates and capacity; reserve appropriate classrooms for specific exam terms so that I can efficiently organize and manage upcoming exams. 

#### Feature breakdown

1. Teacher opens the "Create exam term" form.
2. The system pre-fills course, examiner, default duration.
3. The teacher selects preferred date/time, room, capacity, registration deadline, cancelation deadline, and prerequisites.
4. The system searches for suitable rooms matching capacity, accessibility, and building constraints within the selected date/time.
5. Teacher picks one of the suggested slots/rooms.
6. The system tentatively holds the room.
7. Teacher publishes the exam term.
8. The system confirms the reservation, and releases holds.
9. Notifications are sent to students, examiner, and building services.
10. Teacher can edit the term (time, room, capacity).
11. After the exam, the system locks attendance, releases the room booking, and archives the term.

#### Responsibilities

##### Term specification responsibilities

* Provide a form to input date/time, room, and capacity
* Pre-fill defaults from the course catalog.

##### Room discovery & reservation responsibilities

* Index rooms with capacities, accessibility metadata.
* Search for rooms that satisfy constraints within a time window.
* Temporarily hold selected room until the term is confirmed.
* Confirm room reservation and release any unused holds.

##### Conflict checking responsibilities

* Detect timetable or room conflicts before confirming the term.
* Warn the teacher about conflicts and suggest available alternatives.

##### Notification responsibilities

* Notify staff and students on create/update/cancel.
* Remind registered students before deadlines.

##### Data & integration responsibilities

* Store exam terms, room reservations, and registration data in the system database.
* Integrate with the student information system to access course and student details.
* Export basic reports (exam schedule, and attendance).

##### Post-exam responsibilities

* Lock attendance records after the exam and release the booked room.
* Archive exam term data for reporting and future reference.


### Feature: Registering for the exam terms     

As a student, I need to view the list of available exam terms, then register for a selected exam, and receive confirmation of successful registration. So, I can secure my place for the exam and plan my schedule accordingly.

#### Feature breakdown

1. Student opens the Exam Terms page from their dashboard.
2. The system loads upcoming exam terms for the student’s enrolled courses.
3. Student filters terms by course, teacher, date range, building/room, capacity availability, attempt limits.
4. Student opens a term detail (time, room, capacity, prerequisites, registration deadline, cancellation deadline, conflicts).
5. System checks the student’s eligibility in the background (enrollment, pre-requisites, retake/attempt policy).
6. Student clicks Register.
7. System performs hard validations (Capacity, time conflict, deadline, Attempt policy)
8. System creates the registration record
9. System confirms to the student and shows the registration in My Terms.
10. If any validation fails, system shows a clear error (with fix hints) without losing the student’s filter context.

#### Responsibilities

##### UI/Interaction responsibilities

* Display list of available exam terms with filters.
* Show term detail (capacity, deadline).
* Provide register, degreister actions.

##### Business rules & validation responsibilites

* Verify course enrollment and eligilibity (prerequisites).
* Enforce registration/cancellation deadlines.
* Detect time conflicts with student's other registered terms

##### Data & Integration responsibilites

* Read/write registration records, exam terms and capacity counters in database
* Sync with timetable service. (read room/time to show conflicts)

##### Security & access control responsibilities

* Authorize actions (only the student may register/cancel their own records).
* Prevent registrations for blocked/disciplinary hold accounts.

##### Notifications responsibilities

* Send confirmation of registration and cancellation.
* Notify when a teacher edits/cancels a term affecting the student.

##### Error handling & resilience

* Roll back on failures (capacity, deadlines, conflicts).
* Return user-friendly error messages.


### Feature: Awarding Grades

As a teacher, I want to record and manage students’ exam grades, so that I can evaluate their performance, track progress, and submit final results into the academic system.

#### Feature breakdown

1. Teacher opens the “Award grades” view for a completed exam term.
2. The system displays the list of registered students, their attendance status, and any existing partial results.
3. The teacher inputs grades (numeric, letter, or pass/fail), adds comments or notes if needed.
4. The system validates input (grade format, grading scale, completeness).
5. Teacher submits or saves the grades as a draft.
6. The system stores grades and locks the record once finalized.
7. Notifications are sent to students and course administrators.
8. Teacher can later adjust grades within the allowed correction period.
9. System synchronizes final grades with the Student Information System and updates cumulative statistics.


#### Responsibilities

##### Grade entry & validation responsibilities

* Provide an interface for entering, reviewing, and editing grades.
* Validate grading format and completeness before submission.
* Allow saving in “draft” mode before final confirmation.

##### Data management responsibilities

* Store grade records linked to exam terms, students, and courses.
* Maintain version history for edited grades.
* Synchronize final grades with SIS or gradebook system.

##### Security & access control responsibilities

* Restrict access — only assigned examiners or authorized teachers can edit grades.
* Prevent changes after grades are locked/finalized unless explicitly authorized.

##### Notification responsibilities

* Notify students when grades are published or changed.
* Notify administrators of finalized or adjusted grades.

##### Reporting & analytics responsibilities

* Generate reports on exam outcomes and grade distributions.
* Provide export options for grade sheets (CSV, PDF).

##### Error handling & resilience

* Handle partial submissions gracefully (e.g., save progress).
* Return clear messages when validation or synchronization fails.


### Feature: Viewing Results

As a student, I need to view my exam results once they are published, including grades, examiner comments, 
and credit information, so that I can track my academic performance and verify the correctness of my results.

#### Feature breakdown

1. Student logs into the system and opens the “My Results” or “Exam Results” page.
2. The system retrieves a list of completed exams for which results have been published.
3. Student filters results by course, date, teacher, or grade status (passed/failed/pending).
4. The system displays each exam entry with:
    - Course name and code
    - Exam date and teacher
    - Achieved grade / credit
    - Status (Published / Awaiting Review / Appeal in Progress)
    - Optional examiner comment or feedback.
5. Student opens a result detail view for a specific exam.
6. System shows detailed grade breakdown (if applicable), credit points, and timestamp of publication.
7. Student can download or export the result in PDF or view printable transcript.
8. If the teacher publishes updated grades or corrections, system refreshes the result and notifies the student.
9. If the system allows, student can initiate a grade review or appeal request directly from the result detail page.
10. The system records access logs and audit data for transparency and compliance.

#### Responsibilities

##### UI / Interaction responsibilities

* Provide a Results Dashboard for students with sorting and filtering options.
* Display exam summary (course, grade, date, examiner).
* Support detail view with complete grade and credit information.
* Allow downloading or printing of results/transcripts.

##### Data & Integration responsibilities

* Retrieve grades, credits, and exam records from the central database.
* Sync with the Awarding Grades and Awarding Credits modules.
* Ensure consistency with the teacher’s published data (no early visibility).
* Maintain publication timestamps and version history of grades.

##### Access control & security responsibilities

* Only the student who took the exam can view their results.
* Teachers and administrators have restricted access for review or auditing.
* Enforce data privacy and comply with institutional regulations (e.g., GDPR).

##### Notification responsibilities
 
* Notify students when a result is published or updated.
* Notify teachers when students view or appeal a result (if required by policy).

##### Reporting & export responsibilities
 
* Allow students to export their result history or academic transcript.
* Generate downloadable PDF summaries with institutional formatting.

##### Error handling & resilience

* Gracefully handle missing or delayed data synchronization.
* Show “Result pending publication” message when grades are not yet available.
* Retry retrieval in case of temporary database or network errors.
 
