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