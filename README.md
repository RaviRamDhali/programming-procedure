
Programming Procedure
=====================
Standard Operating Procedure - Standard Programming for Dhali LLC



Helper files for project creation
=====================
t4template-bll.cs

Visiual Studio needed

Using EF Model, the t4template will build pre-populated Class for 
Views - (basic properties)
Controllers (C U D operations)
Presenters (Queries )
Mappers (Custom properties)
Validations (Service side validation)


Project structure:
BLL
DAL <-- T4 will read all EF Models
Web

Create a new project called T4TT
Add t4template-bll.cs to new T4TT project.
Open t4template-bll.cs file and save.
On save the template will run and create several folders with the new project T4TT Make sure to refresh the project and show hidden folders (aka not included files).
