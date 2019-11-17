function handleDrop(canvasarea) {
    if (canvasarea.stopPropagation) {
        canvasarea.stopPropagation(); // stops the browser from redirecting.
    }
    let element = $('.img_dragging')[0];
    DropNewCanvasElement(element, diagramGuid, canvasarea.layerX, canvasarea.layerY);
}

function isUserInDatabase() {
    return axios.get(url);
}

function DropNewCanvasElement(element, diagramGuid, coorx, coory) {

    let objComponent = initializeCanvasCard(element, diagramGuid);

    var objDiagramElement = new Object();
    objDiagramElement.Guid = $(element).data('id');
    objDiagramElement.ConfigurationGuid = $(element).data('configurationid');
    objDiagramElement.DiagramGuid = diagramGuid;
    objDiagramElement.CoorX = coorx;
    objDiagramElement.CoorY = coory;


    axios.post('/api/Diagram', objDiagramElement)
        .then(function (response) {
            if (!response.data.success) {
                return;
            }
            // Update canvas
            buildCanvasCard(objComponent, coorx, coory);
        })
        .catch(function (error) {

        });
}


function initializeCanvasCard(element, diagramGuid) {

    let objComponent = new Object();
    objComponent.diagramId = diagramGuid;
    objComponent.id = $(element).data('id');
    objComponent.name = $(element).data('name');
    objComponent.wmiName = $(element).data('wminame');
    objComponent.ip = $(element).data('ip');
    objComponent.assingedTo = $(element).data('assignedto');
    objComponent.img = $(element).find('img:first').attr('src');
    objComponent.configurationId = $(element).data('configurationid');

    return objComponent;
}

function initializeCanvasCardFromDB(element) {

    let objComponent = new Object();
    objComponent.id = element.guid;
    // objComponent.name = element.name;
    objComponent.wmiName = element.wmiName;
    objComponent.img = element.imgSrc;
    objComponent.diagramId = element.diagramId;
	objComponent.configurationId = element.configurationId;
	// objComponent.user = 'Aaron Coco';
    objComponent.ip = element.ipAddress;
    objComponent.assingedTo = element.assignedTo;

    objComponent.line = element.line;

    // active: true
    // assignedTo: "Joel4"
    // configurationId: "7e6f397d-f5a6-fad2-3e58-7d5966d6d2aa"
    // coorX: 198.19
    // coorY: 64
    // created: "2019-06-14T10:39:07.567"
    // diagramId: "084ca922-1fe9-87eb-bb9b-2618f679fdbd"
    // diagramSiteFullName: null
    // guid: "56d9a76d-d872-4a0f-959c-c7c465ee5202"
    // imgSrc: "https://d18vir2fzaotj1.cloudfront.net/assets/images/components/7.jpg"
    // ipAddress: "10.2.7.13"
    // modified: "2019-06-15T08:58:46.837"
    // name: "LaserJet Pro 400 Color MFP M475dn"
    // parentDiagramElementId: "00000000-0000-0000-0000-000000000000"
    // wmiName: "OEL4-0387"


    return objComponent;
}


