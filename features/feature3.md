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