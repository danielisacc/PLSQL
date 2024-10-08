SPOOL /home/daniel/Documents/Programming/PLSQL/delavega_Lab2.txt;
SET ECHO ON;
-- Daniel Delavega
-- Lab 2
-- Module 2
-- September 25, 2024

drop table Student;
drop table Course;
drop table Student_Course;
-- 2.1
CREATE SEQUENCE list;

DECLARE
    lv_list NUMBER;
    C_XYZ CONSTANT NUMBER(10) := NULL;
    V_Counter1 BINARY_INTEGER;
    V_Row_number theater.ROW_PK%TYPE;
    String_A VARCHAR(50);
BEGIN
    NULL;
END;
/


-- 2.2
CREATE TABLE Student (
    Stu_ID NUMBER(6) PRIMARY KEY,
    Lname VARCHAR2(30),
    Fname VARCHAR2(30),
    Mi CHAR(1),
    Sex CHAR(1),
    Major VARCHAR(30),
    Home_State CHAR(5)
);

CREATE TABLE Course (
    Course_ID VARCHAR2(15) PRIMARY KEY,
    Section NUMBER(4),
    C_Name VARCHAR2(30),
    C_Description VARCHAR2(50)
);

CREATE TABLE Student_Course (
    Stu_ID NUMBER(6),
    Course_ID VARCHAR2(15),
    Section NUMBER(4)
);

DECLARE
    TYPE type_student_course IS RECORD (
        stu_id Student_Course.Stu_ID%TYPE,
        course_id Student_Course.Course_ID%TYPE,
        section Student_Course.Section%TYPE
    );

    TYPE type_course IS RECORD (
        course_id Course.Course_ID%TYPE,
        section Course.Section%TYPE,
        c_name Course.C_Name%TYPE,
        c_description Course.C_Description%TYPE
    );

    TYPE type_student IS RECORD (
        stu_ID Student.Stu_ID%TYPE,
        lname student.Lname%TYPE,
        fname Student.Fname%TYPE,
        mi Student.Mi%TYPE,
        sex Student.Sex%TYPE,
        major Student.Major%TYPE,
        home_state Student.Home_State%TYPE
    );

    TYPE type_students_table IS TABLE OF type_student;
    student_table type_students_table := type_students_table (
        type_student(10011, 'Schmitt', 'Peter', 'M', 'M', 'History', 'Ok'),
        type_student(10012, 'Jones', 'Samson', 'A', 'M', 'English', 'Fl'),
        type_student(10013, 'Peters', 'Amy', 'A', 'F', 'English', 'Me'),
        type_student(10014, 'Johnson', 'John', 'J', 'M', 'CompSci', 'Ca'),
        type_student(10015, 'Penders', 'Alton', 'P', 'F', 'Math', 'Ga'),
        type_student(10016, 'Allen', 'Diana', 'J', 'F', 'Geography', 'Minn'),
        type_student(10017, 'Gillis', 'Jennifer', NULL, 'F', 'CompSci', 'Tx'),
        type_student(10018, 'Johns', 'Roberta', NULL, 'F', 'CompSci', 'Tx'),
        type_student(10019, 'Wise', 'Paula', NULL, 'M', 'Math', 'Cal'),
        type_student(10020, 'Evan', 'Richmond', NULL, 'M', 'English', 'Tx')
    );

    TYPE type_course_table IS TABLE OF type_course;
    course_table type_course_table := type_course_table (
        type_course('COSC1301', 001, 'Intro to Comp.', 'First Computer Course'),
        type_course('ITSE2356', 001, 'Intro to DBA', 'Database Course'),
        type_course('GEOG1791', 002, 'World Geography', 'Second Geography Course'),
        type_course('COSC1315', 001, 'Intro to Prog.', 'Second Computer Course'),
        type_course('ITSE1345', 001, 'Intro to DB Prog.', 'Second Database Course'),
        type_course('ENGL2024', 002, 'English Literature', 'Second English Course'),
        type_course('MATH1102', 001, 'Calculus II', 'Second Math Course'),
        type_course('ENGL1101', 001, 'American Literature', 'First English Course'),
        type_course('MATH1011', 001, 'Trig. and Algebra', 'First Math Course'),
        type_course('GEOG1010', 001, 'Texas Geography', 'First Geology Course')
    );

    TYPE type_student_course_table IS TABLE OF type_student_course;
    student_course_table type_student_course_table := type_student_course_table (
        type_student_course(10011, 'MATH1101', 001),
        type_student_course(10012, 'ENGL2617', 002),
        type_student_course(10013, 'ENGL2617', 001),
        type_student_course(10013, 'ENGL2024', 002),
        type_student_course(10013, 'GEOG1010', 001),
        type_student_course(10014, 'COSC1315', 001),
        type_student_course(10015, 'MATH1101', 001),
        type_student_course(10016, 'GEOG1010', 001),
        type_student_course(10016, 'GEOG1791', 002),
        type_student_course(10017, 'COSC1315', 001),
        type_student_course(10017, 'ITSE2356', 001),
        type_student_course(10018, 'COSC1315', 001),
        type_student_course(10019, 'ITSE2356', 001),
        type_student_course(10020, 'ENGL2024', 002)
    );
BEGIN
    FOR student IN 1 .. student_table.COUNT LOOP
        INSERT INTO Student (Stu_ID, Lname, Fname, Mi, Sex, Major, Home_State)
        VALUES (
            student_table(student).stu_id,
            student_table(student).lname,
            student_table(student).fname,
            student_table(student).mi,
            student_table(student).sex,
            student_table(student).major,
            student_table(student).home_state
        );
    END LOOP;

    FOR course IN 1 .. course_table.COUNT LOOP
        INSERT INTO Course (Course_ID, Section, C_Name, C_Description)
        VALUES (
            course_table(course).course_id,
            course_table(course).section,
            course_table(course).c_name,
            course_table(course).c_description
        );
    END LOOP;

    FOR student_course IN 1 .. student_course_table.COUNT LOOP
        INSERT INTO Student_Course (Stu_ID, Course_ID, Section)
        VALUES (
            student_course_table(student_course).stu_id,
            student_course_table(student_course).course_id,
            student_course_table(student_course).section
        );
    END LOOP;
END;
/

-- 2.3
DECLARE
    lv_stu_id Student.STU_ID%TYPE := 10011;
    lv_num_of_courses NUMBER(3);
BEGIN
    SELECT COUNT(*) As num_of_classes
    INTO lv_num_of_courses
    FROM Student_Course
    WHERE Stu_ID = lv_stu_id;
    DBMS_OUTPUT.PUT_LINE(lv_num_of_courses);
END;
/

-- 2.4
DECLARE
    lv_student_total NUMBER(3);
BEGIN
    SELECT COUNT(*) As student_total
    INTO lv_student_total
    FROM Student;
    DBMS_OUTPUT.PUT_LINE(lv_student_total);
END;
/

-- 2.5
DECLARE
    lv_course_total NUMBER(3);
BEGIN
    SELECT COUNT(DISTINCT Course_ID)
    INTO lv_course_total
    FROM Student_Course;

    If lv_course_total > 10 THEN
        DBMS_OUTPUT.PUT_LINE('More than 10 courses have been established');
    ELSIF lv_course_total < 10 THEN
        DBMS_OUTPUT.PUT_LINE('Less than 10 courses established');
    ELSE
        DBMS_OUTPUT.PUT_LINE('10 courses established');
    END IF;
END;
/

-- 2.6
DECLARE
    lv_instate Student.Home_State%TYPE := 'Tx';
    TYPE type_students IS TABLE OF Student%ROWTYPE
        INDEX BY PLS_INTEGER;
    students type_students;
    instate_students NUMBER(3) := 0;
BEGIN
    SELECT * BULK COLLECT INTO students
    FROM Student;

    FOR student IN 1..students.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(students(student).Stu_ID);
        IF students(student).Home_State = lv_instate THEN
            DBMS_OUTPUT.PUT_LINE('Student is Instate');
            instate_students := instate_students + 1;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Student is out of State');
        END IF;
        DBMS_OUTPUT.PUT_LINE('-------------------');
    END LOOP;
END;
/

-- 2.7
DECLARE
    lv_stu_id Student.STU_ID%TYPE := 10012;
    lv_course_id Course.COURSE_ID%TYPE := 'ENGL2617';
    TYPE type_students_courses IS TABLE OF Student_Course%ROWTYPE
        INDEX BY PLS_INTEGER;
    students_courses type_students_courses;
BEGIN
    SELECT * BULK COLLECT INTO students_courses
    FROM Student_Course
    WHERE STU_ID = lv_stu_id
        AND COURSE_ID = lv_course_id;
    
    DBMS_OUTPUT.PUT_LINE(lv_stu_id || ' ' || lv_course_id);
    IF students_courses.COUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Student is attending specified course');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Student is not attending speciifed course');
    END IF;
END;
/

-- 2.8
DECLARE
    TYPE type_students IS TABLE OF Student%ROWTYPE
        INDEX BY PLS_INTEGER;
    students type_students;
BEGIN
    SELECT * BULK COLLECT INTO students
    FROM STUDENT;

    FOR student IN 1..students.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE('Student : '|| students(student).Stu_ID);
        IF students(student).Sex = 'M' THEN
            DBMS_OUTPUT.PUT_LINE('SEX: MALE');
        ELSIF students(student).Sex = 'F' THEN
            DBMS_OUTPUT.PUT_LINE('SEX: FEMALE');
        ELSE
            DBMS_OUTPUT.PUT_LINE('SEX: UNDECLARED');
        END IF;

        CASE students(student).Major
            WHEN 'Math' THEN DBMS_OUTPUT.PUT_LINE('Major: MATH');
            WHEN 'English' THEN DBMS_OUTPUT.PUT_LINE('Major: ENGLISH');
            WHEN 'CompSci' THEN DBMS_OUTPUT.PUT_LINE('Major: COMPSCI');
            WHEN 'Geography' THEN DBMS_OUTPUT.PUT_LINE('Major: GEOGRAPHY');
            ELSE DBMS_OUTPUT.PUT_LINE('Major: NA');
        END CASE;
        DBMS_OUTPUT.PUT_LINE('-------------------');
    END LOOP;
END;
/

-- 2.9
DECLARE
    TYPE type_students IS TABLE OF Student%ROWTYPE
        INDEX BY PLS_INTEGER;
    students type_students;
    lv_stu_major Student.MAJOR%TYPE;
BEGIN
    SELECT * BULK COLLECT INTO students
    FROM STUDENT;

    FOR student IN 1..students.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE('Student : '|| students(student).Stu_ID);
        IF students(student).Sex = 'M' THEN
            DBMS_OUTPUT.PUT_LINE('SEX: MALE');
        ELSIF students(student).Sex = 'F' THEN
            DBMS_OUTPUT.PUT_LINE('SEX: FEMALE');
        ELSE
            DBMS_OUTPUT.PUT_LINE('SEX: UNDECLARED');
        END IF;
        
        lv_stu_major := students(student).Major;
        IF lv_stu_major = 'Math' THEN DBMS_OUTPUT.PUT_LINE('Major: MATH');
        ELSIF lv_stu_major = 'English' THEN DBMS_OUTPUT.PUT_LINE('Major: ENGLISH');
        ELSIF lv_stu_major = 'CompSci' THEN DBMS_OUTPUT.PUT_LINE('Major: COMPSCI');
        ELSIF lv_stu_major = 'Geography' THEN DBMS_OUTPUT.PUT_LINE('Major: GEOGRAPHY');
        ELSE DBMS_OUTPUT.PUT_LINE('Major: NA');
        END IF;
        DBMS_OUTPUT.PUT_LINE('-------------------');
    END LOOP;
END;
/

-- 2.10
DECLARE
    TYPE type_students IS TABLE OF Student%ROWTYPE
        INDEX BY PLS_INTEGER;
    students type_students;
    counter NUMBER(3);
BEGIN
    SELECT * BULK COLLECT INTO students
    FROM Student;

    counter := students.COUNT;
    WHILE(counter > 0) LOOP
        DBMS_OUTPUT.PUT_LINE(students(counter).Stu_ID);
        counter := counter - 1;
    END LOOP;
END;