$(document).ready(function () {
  $('#download-table').click(() => {
    exportXLS('purchase-table', 'compra.xls');
  });
});

function exportXLS(tableId, filename) {
  let fileType = 'application/vnd.ms-excel;charset=utf-8';
  let tableSelect = $('#' + tableId).clone();
  tableSelect.find("thead > tr > th:last-child").remove();
  tableSelect.find("tbody > tr > td:last-child").remove();
  let dataHTML = escape(tableSelect[0].outerHTML);
  let downloadurl = document.createElement("a");
  if (navigator.msSaveOrOpenBlob) {
    var blob = new Blob(['\ufeff', dataHTML],
      {
        type: fileType
      });
    navigator.msSaveOrOpenBlob(blob, filename);
  }
  else {
    downloadurl.href = 'data:' + fileType + ', ' + dataHTML;
    downloadurl.download = filename;
    downloadurl.click();
  }
}