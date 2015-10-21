$(function () {

    //$.post("http://www.planet-series.tv/saving.php?s=t", function (data) {
    //    $("#toto").html(data);
    //});

    $.ajax({
        url: 'http://www.planet-series.tv/saving.php?s=t',
        type: 'POST',
        crossDomain: true
    }).success(function (data) {
        $("#toto").html(data);
    });

});