const audio = new Audio('https://r2.fivemanage.com/rDF92kFR7F8pjYfg0Fq5U/mixkit-select-click-1109.wav');
const s_hover = new Audio('https://r2.fivemanage.com/R92pivz8ZlXwjJjTvi3Oq/hover.wav');

function sound() {
    audio.currentTime = 0;
    audio.play();
}


window.addEventListener('message', function (event) { 
    var v = event.data
    switch (v.action) {
        case 'show':
            $('.container').show();
        break;

        case 'bolsa':
            $('#bolsaCiega').show();
        break;
        case 'quitarBolsa': 
            $('#bolsaCiega').hide();
        break;
    }
});


$('button').hover(function(){
    s_hover.currentTime = '0';
    s_hover.play();
})

$('#drag').click(function(){
    $.post(`https://${GetParentResourceName()}/drag`);
})

$('#vehiculo').click(function(){
    $.post(`https://${GetParentResourceName()}/vehiculo`);    
})

$('button').click(function(){
    sound();
    CloseAll();
})

$('#cacheo').click(function(){
    $.post(`https://${GetParentResourceName()}/cachear`);
})

$('#bolsa').click(function(){
    $.post(`https://${GetParentResourceName()}/cegar`);
})

$('#esposar').click(function(){
    $.post(`https://${GetParentResourceName()}/esposar`);
})


$(document).keyup((e) => {
    if (e.key === 'Escape') {
        CloseAll();
    }
});


function CloseAll() {
    $('.container').hide();
    $.post(`https://${GetParentResourceName()}/exit`);
}
