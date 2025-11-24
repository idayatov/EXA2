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

