from sqlmodel import Field, SQLModel


class Employee(SQLModel, table=True):
empid: int | None = Field(default=None, primary_key=True)
name: str
dept: int | None = Field(default=None, foreign_key="department.id")
age: int | None = None


class Department(SQLModel, table=True):
id: int | None = Field(default=None, primary_key=True)
name: str


# New Model 1: Project
# Each project belongs to a department, and each project can have a manager which is an Employee.

class Project(SQLModel, table=True):
id: int | None = Field(default=None, primary_key=True)
name: str
description: str | None = None
department_id: int | None = Field(default=None, foreign_key="department.id")
manager_id: int | None = Field(default=None, foreign_key="employee.empid")


# New Model 2: Role
# A Role is assigned to an Employee, and roles can also be linked to a Department as well
class Role(SQLModel, table=True):
id: int | None = Field(default=None, primary_key=True)
title: str
employee_id: int | None = Field(default=None, foreign_key="employee.empid")
department_id: int | None = Field(default=None, foreign_key="department.id")


# New Model 3: Location
# A Location belongs to a Department (for example, a department office or site).
class Location(SQLModel, table=True):
id: int | None = Field(default=None, primary_key=True)
address: str
city: str | None = None
department_id: int | None = Field(default=None, foreign_key="department.id")