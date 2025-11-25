from fastapi import FastAPI, HTTPException, status
from sqlmodel import Session, select
from models import Employee, Department, Project, Role, Location
from database import create_db_and_tables, engine
from contextlib import asynccontextmanager

@asynccontextmanager
async def lifespan(app: FastAPI):
create_db_and_tables()
yield

app = FastAPI(lifespan=lifespan)



# Employee endpoints

@app.get("/employee")
async def read_employees():
    with Session(engine) as session:
        statement = select(Employee)
        results = session.exec(statement).all()
        return results

@app.get("/employee/{id}")
async def read_employee(id: int):
    with Session(engine) as session:
        emp = session.get(Employee, id)
        if not emp:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Employee not found")
        return emp

@app.post("/employee", status_code=status.HTTP_201_CREATED)
async def create_employee(employee: Employee):
    with Session(engine) as session:
        session.add(employee)
        session.commit()
        session.refresh(employee)
        return employee

@app.put("/employee/{item_id}")
async def update_employee(item_id: int, employee: Employee):
    with Session(engine) as session:
        item = session.get(Employee, item_id)
        if not item:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Employee not found")
        item.name = employee.name
        item.dept = employee.dept
        item.age = employee.age
        session.add(item)
        session.commit()
        session.refresh(item)
        return item


@app.delete("/employee/{item_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_employee(item_id: int):
    with Session(engine) as session:
        item = session.get(Employee, item_id)
        if not item:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Employee not found")
        session.delete(item)
        session.commit()
        return {"ok": True}

# Project endpoints
@app.get("/projects")
async def list_projects():
    with Session(engine) as session:
        return session.exec(select(Project)).all()

@app.get("/projects/{project_id}")
async def get_project(project_id: int):
    with Session(engine) as session:
        project = session.get(Project, project_id)
        if not project:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Project not found")
        return project

@app.post("/projects", status_code=status.HTTP_201_CREATED)
async def create_project(project: Project):
    with Session(engine) as session:
        # Optionally, validate foreign keys exist (department, manager)
        if project.department_id:
            if not session.get(Department, project.department_id):
                raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Department not found")
        if project.manager_id:
            if not session.get(Employee, project.manager_id):
                raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Manager (Employee) not found")
        session.add(project)
        session.commit()
        session.refresh(project)
        return project

@app.put("/projects/{project_id}")
async def update_project(project_id: int, project: Project):
    with Session(engine) as session:
        item = session.get(Project, project_id)
        if not item:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Project not found")
        item.name = project.name
        item.description = project.description
        item.department_id = project.department_id
        item.manager_id = project.manager_id
        session.add(item)
        session.commit()
        session.refresh(item)
        return item

@app.delete("/projects/{project_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_project(project_id: int):
    with Session(engine) as session:
        item = session.get(Project, project_id)
        if not item:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Project not found")
        session.delete(item)
        session.commit()
        return {"ok": True}


# Role endpoints
@app.get("/roles")
async def list_roles():
    with Session(engine) as session:
        return session.exec(select(Role)).all()

@app.get("/roles/{role_id}")
async def get_role(role_id: int):
    with Session(engine) as session:
        role = session.get(Role, role_id)
        if not role:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Role not found")
        return role

@app.post("/roles", status_code=status.HTTP_201_CREATED)
async def create_role(role: Role):
    with Session(engine) as session:
        if role.employee_id:
            if not session.get(Employee, role.employee_id):
                raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Employee not found")
        if role.department_id:
            if not session.get(Department, role.department_id):
                raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Department not found")
        session.add(role)
        session.commit()
        session.refresh(role)
        return role

@app.put("/roles/{role_id}")
async def update_role(role_id: int, role: Role):
    with Session(engine) as session:
        item = session.get(Role, role_id)
        if not item:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Role not found")
        item.title = role.title
        item.employee_id = role.employee_id
        item.department_id = role.department_id
        session.add(item)
        session.commit()
        session.refresh(item)
        return item

@app.delete("/roles/{role_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_role(role_id: int):
    with Session(engine) as session:
        item = session.get(Role, role_id)
        if not item:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Role not found")
        session.delete(item)
        session.commit()
        return {"ok": True}

# Location endpoints
@app.get("/locations")
async def list_locations():
    with Session(engine) as session:
        return session.exec(select(Location)).all()

@app.get("/locations/{location_id}")
async def get_location(location_id: int):
    with Session(engine) as session:
        loc = session.get(Location, location_id)
        if not loc:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Location not found")
        return loc

@app.post("/locations", status_code=status.HTTP_201_CREATED)
async def create_location(location: Location):
    with Session(engine) as session:
        if location.department_id:
            if not session.get(Department, location.department_id):
                raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Department not found")
        session.add(location)
        session.commit()
        session.refresh(location)
        return location

@app.put("/locations/{location_id}")
async def update_location(location_id: int, location: Location):
    with Session(engine) as session:
        item = session.get(Location, location_id)
        if not item:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Location not found")
        item.address = location.address
        item.city = location.city
        item.department_id = location.department_id
        session.add(item)
        session.commit()
        session.refresh(item)
        return item

@app.delete("/locations/{location_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_location(location_id: int):
    with Session(engine) as session:
        item = session.get(Location, location_id)
        if not item:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Location not found")
        session.delete(item)
        session.commit()
        return {"ok": True}

# Root endpoints
@app.get("/Welcome")
async def welcome():
    return {"message": "Hello World"}

@app.get("/")
async def root():
    return {"message": "Hello DS"}