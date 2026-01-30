
import requests
import json

# Configuration
API_URL = "http://localhost:5000/api/curriculum/292/semester/81/course"
VERTICAL_ID = 81  # Replace with actual Vertical ID

course_data = [
    {
        "CourseCode": "22AG401",
        "CourseName": "CROP PRODUCTION TECHNOLOGY",
        "CourseType": "CORE",
        "Category": "THEORY WITH LAB",
        "Credit": 4,
        "L": 3,
        "T": 0,
        "P": 2
    },
    {
        "CourseCode": "22AG402",
        "CourseName": "HEAT AND MASS TRANSFER",
        "CourseType": "CORE",
        "Category": "THEORY WITH LAB",
        "Credit": 4,
        "L": 3,
        "T": 0,
        "P": 2
    },
    {
        "CourseCode": "22AG403",
        "CourseName": "STRENGTH OF MATERIALS",
        "CourseType": "CORE",
        "Category": "THEORY/LAB",
        "Credit": 4,
        "L": 2,
        "T": 1,
        "P": 2
    },
    {
        "CourseCode": "22AG404",
        "CourseName": "THEORY OF MACHINES",
        "CourseType": "CORE",
        "Category": "THEORY WITH LAB",
        "Credit": 4,
        "L": 3,
        "T": 0,
        "P": 2
    },
    {
        "CourseCode": "22AG405",
        "CourseName": "HYDROLOGY",
        "CourseType": "CORE",
        "Category": "THEORY",
        "Credit": 4,
        "L": 3,
        "T": 1,
        "P": 0
    },
    {
        "CourseCode": "22AG040",
        "CourseName": "TECHNOLOGY OF SEED PROCESSING",
        "CourseType": "ELECTIVE 1",
        "Category": "THEORY",
        "Credit": 3,
        "L": 3,
        "T": 0,
        "P": 0
    }
]

def upload_courses():
    url = API_URL.format(vertical_id=VERTICAL_ID)
    
    for course in course_data:
        payload = {
            "course_code": course['CourseCode'],
            "course_name": course['CourseName'],
            "course_type": course['CourseType'],
            "category": course['Category'],
            "credit": course['Credit'],
            "lecture_hrs": course['L'],
            "tutorial_hrs": course['T'],
            "practical_hrs": course['P'],
            "cia_marks": 40,  # Defaulting based on common standards
            "see_marks": 60,
            "total_marks": 100
        }
        
        response = requests.post(url, json=payload)
        
        if response.status_code == 201:
            print(f"Successfully added: {course['CourseCode']}")
        else:
            print(f"Failed {course['CourseCode']}: {response.text}")

if __name__ == '__main__':
    upload_courses()
