Swal.fire({
    title: 'Loading ...',
    text: 'Found ' + nodeDataList.length + ' configurations',
    showConfirmButton: false,
    timer: 2500,
    onBeforeOpen: () => {
        Swal.showLoading();
    },
    onClose: () => {
        initGoJS(this.diagramElementData);
    }
});
