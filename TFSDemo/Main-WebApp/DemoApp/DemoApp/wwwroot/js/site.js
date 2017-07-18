function jsonProcessor(data) {
    console.log(data);
}

$(document).ready(function () {
    $.ajax({
        url: "http://webapi.demo.com/api/values",
        dataType: 'jsonp',
        jsonp: false,
        jsonpCallback: "jsonProcessor",
        success: function (data) {
            $('#messageFromApi').text(data.Message).css('color', data.Color);
        },
        error: function () {
            debugger;
        }
    });
});