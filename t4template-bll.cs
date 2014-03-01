<#@ template language="C#" debug="false" hostspecific="true"#>
<#@ import namespace="System.IO" #>
<#@ import namespace="Microsoft.VisualStudio.TextTemplating" #>
<#@ include file="EF.Utility.CS.ttinclude"#>
<#@ output extension=".cs"#>
<#

// Change Log v2.1
// 
//
//
//
// 03/01/2014 : Update all areas (crazy rain in socal)




// Initialization
string templateDirectory = Path.GetDirectoryName(Host.TemplateFile);
CodeGenerationTools code = new CodeGenerationTools(this);
MetadataLoader loader = new MetadataLoader(this);
CodeRegion region = new CodeRegion(this, 1);
MetadataTools ef = new MetadataTools(this);
     
// Please set the options here 

bool overwrite = true;
string inputFile = @"..\\DAL\\Model.edmx";   //** CHANGE SETTINGS  **
var dalNamespace = "DAL";                    //** CHANGE SETTINGS  **   
// string tablePrefix = "c_";                   //** CHANGE SETTINGS  Not used**

// var modelNames = new string[] {"c_master"};   //** CHANGE SETTINGS  for LIST OF TABLES**
var modelNames = new string[] {};                //** CHANGE SETTINGS  for ALL TABLES in DB**
    
EdmItemCollection ItemCollection = loader.CreateEdmItemCollection(inputFile);
EntityContainer container = ItemCollection.GetItems<EntityContainer>().FirstOrDefault();
    
// Defining namespaces
// string namespaceName = code.VsNamespaceSuggestion();  //** DEFAULT NameSpace **
string namespaceName = "BLL";  //** CHANGE NameSpace to BLL**

string namespaceNameViews = namespaceName + ".Views";
string namespaceNameControllers = namespaceName + ".Controllers";
string namespaceNamePresenters = namespaceName + ".Presenters";
string namespaceNameMappers = namespaceName + ".Mappers";
string namespaceNameValidations = namespaceName + ".Validations";
var namspaceNames = new string [] {dalNamespace, namespaceName, namespaceNameViews, namespaceNameControllers, namespaceNamePresenters, namespaceNameMappers, namespaceNameValidations};

// Checking folders
CheckFolder("Views");
CheckFolder("Controllers");
CheckFolder("Presenters");
CheckFolder("Mappers");
CheckFolder("Validations");

CheckFolder("HTML");


foreach (EntityType entity in ItemCollection.GetItems<EntityType>().Where(u => modelNames.Count() == 0 || modelNames.Contains(u.Name)).OrderBy(e => e.Name))
{
    // string realEntityName = entity.Name.Replace(tablePrefix, string.Empty);  //<-- remove leading table name
    string realEntityName = entity.Name;
    int index = 0;
    while(index <= realEntityName.Length){
        int p = realEntityName.IndexOf("_", index);
        if( p!=-1 ){
            realEntityName = realEntityName.Substring(0, p) + realEntityName.Substring(p+1,1).ToUpper() + realEntityName.Substring(p+2);
            index = p++;
        }
        else
            break;
    }
    realEntityName = FixName(realEntityName);

// Creating ValidationView -----------------------------------------------------------------------------
    WriteHeader(namspaceNames);
    BeginNamespace(namespaceNameViews, code);
#>
public class ValidationView {
    public string ValidationField { get; set; }
    public string ValidationMessage { get; set; }
}
<# 
    EndNamespace(namespaceNameViews);
    WriteFile("Views", "ValidationView.cs", overwrite);

 // Creating HTML------------------------------------------------------------------------
    WriteHtmlFormHeader(realEntityName);
    //BeginNamespace(namespaceNameMappers, code);
#>
<#foreach (EdmProperty edmProperty in entity.Properties.Where(p => p.TypeUsage.EdmType is PrimitiveType && p.DeclaringType == entity))
    {
        string realPropertyName = code.Escape(edmProperty);
        realPropertyName = FixName(realPropertyName);
        string realPropertyField = FixName(realPropertyName).ToLower();
#>
        <div class="control-group clearfix">
            <div class="span4">
                <label><#=realPropertyName#></label>
                <input type="text" name="<#=realPropertyField#>" id="<#=realPropertyField#>" value="@Model.<#=realPropertyName#>" class="required" />
            </div>
        </div>

<# } #>

        <div class="control-group clearfix">
            <div class="span4">
                <label>active</label>
                <input type="checkbox" id="active" name="active" checked="@Model.Active"/>
            </div>
        </div>

        <div class="control-group clearfix">
            <button class="btnSubmit btn btn-success"> Submit </button>
            <input type="hidden" id="hdGuid" name="hdGuid" value="@Model.Guid" />
        </div>

<# 
    WriteHtmlFormFooter();
    //EndNamespace(namespaceNameMappers);
    WriteFile("HTML", realEntityName + ".htm", overwrite);

// Creating Views-----------------------------------------------------------------------------
    WriteHeader(namspaceNames);
    BeginNamespace(namespaceNameViews, code);
#>

public class <#= realEntityName #> {

    public class Extend : DbModel
    {
        //
    }

    public class DbModel
    {
<#foreach (EdmProperty edmProperty in entity.Properties.Where(p => p.TypeUsage.EdmType is PrimitiveType && p.DeclaringType == entity))
    {
        string realPropertyName = code.Escape(edmProperty);
        realPropertyName = FixName(realPropertyName);
    #>
        public <#= code.Escape(edmProperty.TypeUsage) #> <#=realPropertyName#> { get; set; }
<# } #>
    }

}

<# 
    EndNamespace(namespaceNameViews);
    WriteFile("Views", realEntityName + "View.cs", overwrite);

// Creating Presenters------------------------------------------------------------------------
    WriteHeader(namspaceNames);
    BeginNamespace(namespaceNamePresenters, code);
#>

public static class <#= realEntityName #> {

    public static List<Views.<#=realEntityName#>.Extend> GetAll()
    {
        using (var ctx = new <#=code.Escape(container)#>())
        {
            var data = ctx.<#=entity.Name#>.OrderBy(h => h.sort).ToList();
            return data.Select(Mappers.<#=realEntityName#>.Basic).ToList();
        }
    }

    public static List<Views.<#=realEntityName#>.Extend> GetActive()
    {
        using (var ctx = new <#=code.Escape(container)#>())
        {
            var data = ctx.<#=entity.Name#>.Where(h =>h.active).OrderBy(h => h.sort).ToList();
            return data.Select(Mappers.<#=realEntityName#>.Basic).ToList();
        }
    }

    public static Views.<#=realEntityName#>.Extend GetById(int id)
    {
        using (var ctx = new <#=code.Escape(container)#>())
        {
            var data = ctx.<#=entity.Name#>.FirstOrDefault(h => h.id == id);
            return data != null ? Mappers.<#=realEntityName#>.Basic(data) : null;
        }
    }

    public static Views.<#=realEntityName#>.Extend GetByGuid(Guid guid)
    {
        using (var ctx = new <#=code.Escape(container)#>())
        {
            var data = ctx.<#=entity.Name#>.FirstOrDefault(h => h.guid == guid);
            return data != null ? Mappers.<#=realEntityName#>.Basic(data) : null;
        }
    }

}
<# 
    EndNamespace(namespaceNamePresenters);
    WriteFile("Presenters", realEntityName + "Presenter.cs", overwrite);

// Creating Mappers------------------------------------------------------------------------
    WriteHeader(namspaceNames);
    BeginNamespace(namespaceNameMappers, code);
#>

public static class <#= realEntityName #> {

    public static Views.<#= realEntityName #>.Extend Basic(DAL.<#=entity.Name#> data)
    {
        var view = new Views.<#= realEntityName #>.Extend();

<#foreach (EdmProperty edmProperty in entity.Properties.Where(p => p.TypeUsage.EdmType is PrimitiveType && p.DeclaringType == entity))
    {
        string realPropertyName = code.Escape(edmProperty);
        realPropertyName = FixName(realPropertyName);
#>
        view.<#= realPropertyName #> = data.<#= edmProperty #>;
<# } #>

        view.ActiveYesNo = (data.active) ? "Yes" : "No";

        return view;
    }
}
<# 
    EndNamespace(namespaceNameMappers);
    WriteFile("Mappers", realEntityName + "Mapper.cs", overwrite);

// Creating Controllers------------------------------------------------------------------------
    WriteHeader(namspaceNames);
    BeginNamespace(namespaceNameControllers, code);
#>

public class <#= realEntityName #> {

        public static Views.<#= realEntityName #>.Extend Create(Views.<#= realEntityName #>.Extend view) {

            var data = new DAL.<#=entity.Name#>();

            try
            {
                using (var ctx = new <#=code.Escape(container)#>())
                {
                    if (view.Id == 0)
                    {

<#foreach (EdmProperty edmProperty in entity.Properties.Where(p => p.TypeUsage.EdmType is PrimitiveType && p.DeclaringType == entity))
    {
        string realPropertyName = code.Escape(edmProperty);
        realPropertyName = FixName(realPropertyName);
#>
                    data.<#= edmProperty #> = view.<#= realPropertyName #>;
<# } #>

                    ctx.<#=entity.Name#>s.Add(data);
                    ctx.SaveChanges();
                    
                    Tracker.Track(TrackingState.Created, "Created <#=entity.Name#>", "<#=entity.Name#>", data.id);
                }
            }
        }
        catch (Exception ex)
        {
            data = new DAL.<#=entity.Name#>();
            ErrorHandler.InsertErrorInfo(ex, ErrorState.Significant, "<#= realEntityName #>Controller.Create");
        }

        return Mappers.<#= realEntityName #>.Basic(data);
    }

        public static Views.<#= realEntityName #>.Extend Update(Views.<#= realEntityName #>.Extend view) {

            var data = new DAL.<#=entity.Name#>();

            try
            {
                using (var ctx = new <#=code.Escape(container)#>())
                {
                    data = ctx.<#=entity.Name#>s.FirstOrDefault(c => c.guid == view.Guid);

                    if (data != null)
                    {

<#foreach (EdmProperty edmProperty in entity.Properties.Where(p => p.TypeUsage.EdmType is PrimitiveType && p.DeclaringType == entity))
    {
        string realPropertyName = code.Escape(edmProperty);
        realPropertyName = FixName(realPropertyName);
#>
                    data.<#= edmProperty #> = view.<#= realPropertyName #>;
<# } #>

                    ctx.SaveChanges();
                    
                    Tracker.Track(TrackingState.Updated, "Updated <#=entity.Name#>", "<#=entity.Name#>", data.id);
                }
            }
        }
        catch (Exception ex)
        {
            data = new DAL.<#=entity.Name#>();
            ErrorHandler.InsertErrorInfo(ex, ErrorState.Significant, "<#= realEntityName #>Controller.Update");
        }

        return Mappers.<#= realEntityName #>.Basic(data);
    }

        public static bool Delete(int id)
        {
            try
            {
                using (var ctx = new <#=code.Escape(container)#>())
                {
                    var data = ctx.<#=entity.Name#>s.FirstOrDefault(c => c.id == id);
                    if (data != null)
                    {
                        ctx.<#=entity.Name#>s.Remove(data);
                        ctx.SaveChanges();
                        Tracker.Track(TrackingState.Deleted, "Delete <#=entity.Name#>s", "<#=entity.Name#>", data.id);
                    }
                }
            }
            catch (Exception ex)
            {
                ErrorHandler.InsertErrorInfo(ex, ErrorState.Significant, "<#= realEntityName #>Controller.Delete by Id");
                return false;
            }

            return true;
        }

        public static bool Delete(Guid guid)
        {
            try
            {
                using (var ctx = new <#=code.Escape(container)#>())
                {
                    var data = ctx.<#=entity.Name#>s.FirstOrDefault(c => c.guid == guid);
                    if (data != null)
                    {
                        ctx.<#=entity.Name#>s.Remove(data);
                        ctx.SaveChanges();
                        Tracker.Track(TrackingState.Deleted, "Delete <#=entity.Name#>s", "<#=entity.Name#>", data.id);
                    }
                }
            }
            catch (Exception ex)
            {
                ErrorHandler.InsertErrorInfo(ex, ErrorState.Significant, "<#= realEntityName #>Controller.Delete by Guid");
                return false;
            }

            return true;
        }


}
<# 
    EndNamespace(namespaceNameControllers);
    WriteFile("Controllers", realEntityName + "Controller.cs", overwrite);
    // Creating Validations------------------------------------------------------------------------
    WriteHeader(namspaceNames);
    BeginNamespace(namespaceNameValidations, code);
#>

public class <#= realEntityName #> {

        public static List<ValidationView> Validate(Views.<#= realEntityName #>.Extend view) {

            var error = new List<ValidationView>();

<#foreach (EdmProperty edmProperty in entity.Properties.Where(p => !p.Nullable && p.TypeUsage.EdmType is PrimitiveType && p.DeclaringType == entity))
    {
        string realPropertyName = code.Escape(edmProperty);
        realPropertyName = FixName(realPropertyName);
#>
                    if (view.<#=realPropertyName#> == null || string.IsNullOrEmpty(view.<#=realPropertyName#>.ToString())){
                        var validationview = new ValidationView();
                        validationview.ValidationField = "<#= edmProperty #>";
                        validationview.ValidationMessage = "<#=realPropertyName#> is required";
                        error.Add(validationview);
                    }

<# } #>
        return error;
    }
}
<# 
    EndNamespace(namespaceNameControllers);
    WriteFile("Validations", realEntityName + "Validator.cs", overwrite);
}
#>
<#+

string FixName(string name){
    return name.Substring(0,1).ToUpper() + name.Substring(1);
}

void CheckFolder(string folder){
    string directory = Path.GetDirectoryName(Host.TemplateFile);
    directory = Path.Combine(directory, folder);
    if(!System.IO.Directory.Exists(directory))
        System.IO.Directory.CreateDirectory(directory);
}

void WriteFile(string folder, string file, bool overwrite){
    string templateDirectory = Path.GetDirectoryName(Host.TemplateFile);
    string outputFilePath = Path.Combine(templateDirectory,folder, file);

    if(file.ToLower() == "debug.txt" || !File.Exists(outputFilePath) || overwrite)
        File.WriteAllText(outputFilePath, this.GenerationEnvironment.ToString()); 
    this.GenerationEnvironment.Remove(0, this.GenerationEnvironment.Length);
}

void WriteHeader(params string[] extraUsings)
{
#>
//------------------------------------------------------------------------------
// <auto-generated>	This code was generated from a T4 template on:
//		<#= DateTime.Now.ToString() #> 
// </auto-generated>
//------------------------------------------------------------------------------

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
<#=String.Join(String.Empty, extraUsings.Select(u => "using " + u + ";" + Environment.NewLine).ToArray())#>

<#+
}
   
void BeginNamespace(string namespaceName, CodeGenerationTools code)
{
    CodeRegion region = new CodeRegion(this);
    if (!String.IsNullOrEmpty(namespaceName))
    {
#>
namespace <#=code.EscapeNamespace(namespaceName)#> {
<#+
        PushIndent(CodeRegion.GetIndent(1));
    }
}

void EndNamespace(string namespaceName)
{
    if (!String.IsNullOrEmpty(namespaceName))
    {
        PopIndent();
#>
}
<#+
    }
}

void WriteHtmlFormHeader(string realEntityName)
{
#>
<script type="text/javascript">
    $(document).ready(function () {
        
        var formMain = $("#form-main");
        $(formMain).validate();

        $(formMain).submit(function () {
            // Validation Failed
            if (!$(formMain).valid()) { return false; }

            // Process Form
            $.post('/<#=realEntityName#>/Post', $(this).serialize(), function (data) {
                  if (data.success) {
                      window.location = "/<#=realEntityName#>?st=success";
                  } else {
                      alert(data.message);
                      ProcessServerValidation(data);
                  }
              });
            return false;
        });


    });
</script>

<h1> <#=realEntityName#> </h1>

<form action="/" method="POST" id="form-main">

<#+
}

void WriteHtmlFormFooter()
{
#>
</form>
<#+
}

#>
