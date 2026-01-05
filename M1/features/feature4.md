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
 
