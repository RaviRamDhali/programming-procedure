// Define a new component called button-counter
Vue.component('config-list', {
    template: '<div class="card card-container widget-user" :data-configurationId="item.guid"> <div class="card-body card-configuration" v-bind:class="{img_dragging:cmpntIsDragging}" data-diagramId="@ViewBag.diagramId" :draggable="!item.diagramElement" v-on:dragstart="dragstart(item, $event)" :data-id="item.guid" :data-name="item.name" :data-configurationId="item.guid" :data-assignedTo="item.assignedTo" :data-ip="item.ipAddress" :data-wminame="item.wmI_Name" :data-diagramelement=" (item.diagramElement) ? item.diagramElement.guid : null"> <div class="media"> <div class="media-left pr-1"><img v-bind:src="item.imgSrc" class="img-sm"></div> <div class="media-body"> <h5 class="media-heading mt-0 mb-0">{{item.name}}</h5> <span class="badge badge-outline text-primary">{{item.typeTitle}}</span> <span class="badge badge-outline text-primary">{{item.assignedTo}}</span> <span class="badge badge-outline text-primary">{{item.wmI_Name}}</span> <span class="badge badge-outline text-primary">{{item.ipAddress}}</span> </div> </div><div class="user-position"><span class="badge" v-bind:class="statusCssClass" v-bind:title="item.statusTitle">&nbsp;</span></div></div> </div>', //template: '#checkbox-template',
    props: ['item', 'isDragging'],
    data: function () {
        return {
            cmpntIsDragging: this.isDragging,
            statusCssClass: "badge-" + this.item.statusCssClass
        };
    },
    methods: {
        dragstart: function (item, e) {
            var items = document.getElementsByClassName("img_dragging");
            for (let i = 0; i < items.length; i++) {
                items[i].classList.remove('img_dragging');
            }
            this.cmpntIsDragging = true;
        }
    }
});





new Vue({
        el: '#app',
        data: {
            defaultName: "Configuration Components",
            siteName: null,
            showCanvasMessage: true,
            configurations: [],
            configurations_assigned: [],
            configurations_notassigned: [],
            sites: [],
            companyid: companyGuid,
            diagrams: [],
            diagramName: null,
            diagramid: null,
            selectedSite:null,
            selectedDiagram:'',
            isDragging: false
        },
        mounted: function () {
            var vdata = this;



            axios.get("/api/configuration/" + this.companyid)
                .then(function (response) {
                    vdata.configurations = response.data;
                    vdata.configurations_assigned = vdata.configurations.filter(function (config) {
                        return config.diagramElement !== null;
                    });
                    vdata.configurations_notassigned = vdata.configurations.filter(function (config) {
                        return config.diagramElement === null;
                    });



                });
                // .then(response => {
                //     this.configurations = response.data
                //     this.configurations_assigned = this.configurations.filter(config => {
                //             return config.DiagramElement != null
                //     });
                //     this.configurations_notassigned = this.configurations.filter(config => {
                //         return config.DiagramElement === null
                //     });
                // });

            axios.get("/api/sites/" + this.companyid)
                .then(function (response) {
                    vdata.sites = response.data;
                    if(response.data.length === 1){
                        var _selectedSite = vdata.sites[0];
                        vdata.selectedSite = _selectedSite.SiteId;
                        vdata.siteChanged(_selectedSite.SiteId, _selectedSite.SiteName);
                    }else{
                        $('.modal-site').modal('show');
                    }
                });
        },
        methods: {
            siteChanged: function (siteid, sitename) {
                if (!siteid)
                    return;

                this.defaultName = null;
                this.siteName = sitename;
                var filterDiagrams = this.filterDiagrams(siteid);
                this.diagrams = filterDiagrams[0].Diagrams;

                if (this.diagrams.length === 1) {
                    var _selectedDiagram = this.diagrams[0];
                    this.selectedDiagram = _selectedDiagram.Value;
                    this.diagramChanged(_selectedDiagram.Value, _selectedDiagram.Text);
                    $('.modal-site').modal('hide');
                }

            },
            diagramChanged: function name(diagramid, diagramname) {

                if (!diagramid)
                    return;

                this.diagramid = diagramid;
                this.diagramName = " > " + diagramname;
                this.showCanvasMessage = false;
                diagramGuid = diagramid;
                this.getDiagramElement(this.companyid, this.diagramid);
            },
            siteChangedDefaults: function () {
                this.showCanvasMessage = true;
                this.defaultName = "Configuration Components";
                this.siteName = null;
                this.diagrams = null;
                this.diagramName = null;
                this.diagramid = null;
                this.selectedDiagram = '',
                RemoveAllObjectsFromCanvasCard();
            },
            diagramChangedDefaults: function () {
               this.showCanvasMessage = true;
               this.diagramName = null;
               this.diagramid = null;
               RemoveAllObjectsFromCanvasCard();
            },
            onChangeSite: function (e) {
                this.siteChangedDefaults();
                var _siteid = e.target.value;
                var _sitename = e.target.options[e.target.options.selectedIndex].text;
                this.siteChanged(_siteid, _sitename);
            },
            onChangeDiagram: function (e) {
                this.diagramChangedDefaults();
                var _diagramid = e.target.value;
                var _diagramName = e.target.options[e.target.options.selectedIndex].text;
                this.diagramChanged(_diagramid, _diagramName);
            },
            getDiagramElement: function (companyid, diagramid) {
                axios.get('/api/diagram/' + companyid + "/" + diagramid)
                    .then(function (response) {
                        let diagramElementData = response.data;
                        drawDiagramElement(diagramElementData);
                    })
                    .catch(function (error) {
                        console.log(error);
                        return error;
                    });
            },

            filterDiagrams: function (siteid) {
                return this.sites.filter(function (site) {
                    return site.SiteId === siteid;
                });
            },
            config_assigned: function name(e) {
                this.configurations_assigned.splice(0, 1);
            },
            config_not: function name(e) {
            }
        }
    });

Vue.config.devtools = true;


