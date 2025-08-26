var visitSenderId = 0;

var player1 = "John Doe";
var player2 = "Sam Francis";
var player1Data = {};
var player2Data = {};
var currentPlayer = player1;
var player1Score = 0;
var player2Score = 0;
var round = 1;
var maxRounds = 1; 
var dieOne = $('.casino-die-one');
var dieTwo = $('.casino-die-two');
var diceCircle = $('.casino-dice-circle');
var rollButton = $('.casino-roll-button');
var player1ScoreElement = $('.casino-player-left .casino-score');
var player2ScoreElement = $('.casino-player-right .casino-score');
var player2ScoreElement = $('.casino-round-info');
var circleWidth = diceCircle.width();
var circleHeight = diceCircle.height();
var dieSize = dieOne.width();
var currentItemSlot = 0;
var panelIndex = 0;
// var consecutiveMisses = 0;

window.addEventListener("message", function(e) {
    e = e.data
    switch (e.action) {
        case "openJailMenu":
            return openJailMenu(e);
        case "openJailList":
            return openJailList(e);
        case "activejailmenu":
            return jailmenu(e);
        case "visitMenu":
            return visitMenu(e);   
        case "visitRequestResponse":
            return visitRequestResponse(e.data); 
        case "visitResponse":
            return handleVisitResponse(e);
        case "closeJailMenu":
            return closeJailMenu();
        case "openDice":
            return openDice(e);
        case "switchTurn":
            if (e.player.name === player1) {
                rollButton.prop('disabled', false).css({
                    'opacity': 1,
                    'cursor': 'pointer'
                }).text('Roll Dice');
            } else if (e.player.name === player2) {
                rollButton.prop('disabled', false).css({
                    'opacity': 1,
                    'cursor': 'pointer'
                }).text('Roll Dice');
            }
            return;
        case "diceResult":
            return diceResult(e);
        case "syncRoll":
            return syncRoll(e);
        case "openNotebook":
            return openNotebook(e);
        case "cutElectricPanel":
            return cutElectricPanel(e);
        case "tunnelGame":
            return tunnelGame(e);
        case "convert":
            return Convert(e.pMugShotTxd, e.removeImageBackGround, e.id);
        default:
            return;
    }
});

function diceResult(e) {
    const data = e.result;

    const myId = data.you;
    const winnerId = data.winner;

    const isWinner = myId === winnerId;

    const myRoll1 = data.myRoll.die1;
    const myRoll2 = data.myRoll.die2;

    $('.casino-die-one').html(myRoll1);
    $('.casino-die-two').html(myRoll2);

    $('.left-player').text(myId === winnerId ? "You" : "Opponent");
    $('.right-player').text(myId !== winnerId ? "You" : "Opponent");

    if (isWinner) {
        $('.casino-player-left .casino-winner-text').show();
        $('.casino-player-right .casino-winner-text').hide();
    } else {
        $('.casino-player-right .casino-winner-text').show();
        $('.casino-player-left .casino-winner-text').hide();
    }

    $('.casino-roll-button').prop('disabled', true).text('Waiting...');

    setTimeout(() => {
        $('body').fadeOut(150);
        $.post('https://frkn-prison/closeJailUI', JSON.stringify({}));
    }, 4000);

}


function tunnelGame(e) { 
    $('.minigame-wrapper, body').fadeIn(150).css('display', 'flex');

    $('body').css({
        'background': 'transparent !important',
        'background-color': 'transparent !important'
    });

    $('.minigame-inner').css('left', '70%').animate({
        left: '30%'
    }, 500); 

    startDigGame();
}


function cutElectricPanel(e) {
    panelIndex = e.panelIndex || 0;
    consecutiveMisses = 0;
    gameFinished = false;
    dragging = false;
    allowFail = false;
    offset = { x: 0, y: 0 };
    $('.svg-holder').attr('style', 'left: -71%; top: 35%;');

    $('.svg-holder').css({
        left: '-71% !important',
        top: '35% !important',
    });

    $('.app-container, .container , .prisoner-widget-container').fadeOut(150).css('display', 'none');
    $('body , .game-container').fadeOut(150).css('display', 'flex');


        const canvas = document.getElementById("danger-canvas");
    const ctx = canvas.getContext("2d");
    canvas.width = canvas.offsetWidth;
    canvas.height = canvas.offsetHeight;

    const points = [];
    let y = 15;
    for (let x = 0; x <= canvas.width; x += 20) {
        y += Math.random() * 10;
        if (y < 10) y = 10;
        if (y > canvas.height - 10) y = canvas.height - 10;
        points.push({
            x,
            y
        });
    }



    ctx.strokeStyle = "white";
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.moveTo(points[0].x, points[0].y);
    for (let i = 1; i < points.length; i++) {
        ctx.lineTo(points[i].x, points[i].y);
    }
    ctx.stroke();


    $("#svg-holder").on("mousedown", function(e) {
        dragging = true;
        const pos = $(this).offset();
        offset.x = e.pageX - pos.left;
        offset.y = e.pageY - pos.top;
    });

    $(document).on("mouseup", function() {
        dragging = false;
    });

    $(document).on("mousemove", function(e) {
        if (!dragging) return;

        const area = $(".game-area");
        const svg = $("#svg-holder");
        let left = e.pageX - area.offset().left - offset.x;
        let top = e.pageY - area.offset().top - offset.y;

        const maxX = area.width() - svg.width();
        const maxY = area.height() - svg.height();

        if (left < -250) left = 0;

        if (top < 0) top = 0;
        if (top > maxY) top = maxY;
        svg.css({
            left: left + "px",
            top: top + "px"
        });

        
        const rect = svg[0].getBoundingClientRect();
        const width = rect.width;
        const height = rect.height;

        if (width === 0 || height === 0) {
            return;
        }

        const canvasRect = canvas.getBoundingClientRect();
        const imageData = ctx.getImageData(rect.left - canvasRect.left, rect.top - canvasRect.top, width, height);

        let hitPixels = 0;
        for (let i = 0; i < imageData.data.length; i += 4) {
            const r = imageData.data[i];
            const g = imageData.data[i + 1];
            const b = imageData.data[i + 2];
            if (r === 255 && g === 255 && b === 255) {
                allowFail = true;
                imageData.data[i] = 0;
                imageData.data[i + 1] = 255;
                imageData.data[i + 2] = 0;
                hitPixels++;
            }
        }
        if (left > maxX) {
            if (hitPixels == 0) {
                $('body , .game-container').fadeOut(150).css('display', 'none');
                $.post('https://frkn-prison/failedCut', JSON.stringify({}));
                $('.svg-holder').css({
                    left: '-71% !important',
                    top: '35% !important',
                });
            }

            left = maxX;
            gameFinished = true

            $.post('https://frkn-prison/successCut', JSON.stringify({
                panelIndex: panelIndex
            }));
            $('body , .game-container').fadeOut(150).css('display', 'none');
              $('.svg-holder').css({
                    left: '-71% !important',
                    top: '35% !important',
                });
            return;
        }

        const totalPixels = imageData.data.length / 4;
        const hitRatio = hitPixels / totalPixels;

        const zones = $(".zone");
        zones.each(function() {
            const zoneLeft = $(this).position().left;
            const zoneRight = zoneLeft + $(this).outerWidth();
            if (left + svg.width() > zoneLeft && left < zoneRight) {
                $(this).addClass("active");
                setTimeout(() => $(this).removeClass("active"), 500);
            }
        });

        if (hitRatio === 0) {
            consecutiveMisses++;
        } else {
            consecutiveMisses = 0;
        }

        if (consecutiveMisses >= 25 && allowFail) {
            $('body , .game-container').fadeOut(150).css('display', 'none');
            consecutiveMisses = 0;
            $.post('https://frkn-prison/failedCut', JSON.stringify({}));
            $('.svg-holder').css({
                left: '-71% !important',
                top: '35% !important',
            });
            return 
        };



        if (hitRatio != 0) {
            if (hitRatio < 0.0002 && allowFail) {
                $('body , .game-container').fadeOut(150).css('display', 'none');
                $.post('https://frkn-prison/failedCut', JSON.stringify({}));
                $('.svg-holder').css({
                    left: '-71% !important',
                    top: '35% !important',
                });
                return;
            } else {
                ctx.putImageData(imageData, rect.left - canvasRect.left, rect.top - canvasRect.top);
            }
        }

    });

}

function openNotebook(e) { 
    $('.app-container, .container , .prisoner-widget-container').fadeOut(150).css('display', 'none');

    $('.notebook-container , body').fadeIn(200).css('display', 'flex');

    $('.notebook-textarea').val(e.note.content || '')

    currentItemSlot = e.slot || 0;
}

$(document).on('click', '.notebook-save-button', function() {
    $.post('https://frkn-prison/noteBookSave', JSON.stringify({
        text : $('.notebook-textarea').val(),
        slot: currentItemSlot
    }));
    $('.notebook-container , body').fadeOut(150).css('display', 'none');
})

$(document).on('click', '.notebook-cancel-button', function() {
    $('.notebook-container , body').fadeOut(150).css('display', 'none');
    $.post('https://frkn-prison/closeJailUI', JSON.stringify({}));
});


function syncRoll(e) { 
       if (round > maxRounds) {
        declareWinner();
        return;
    }

    rollButton.prop('disabled', true).text('Zarlar Atılıyor...');
    $('.casino-winner-text').hide().css({
        'opacity': 0,
        'transform': 'scale(0.5) translateY(20px)'
    });
    dieOne.empty();
    dieTwo.empty();

    var rollDuration = 1000;
    var intervalTime = 50;
    var startTime = Date.now();

    function animateSync(dieElement) {
        var currentRotationX = 0;
        var currentRotationY = 0;
        var currentRotationZ = 0;
        var interval = setInterval(function() {
            if (Date.now() - startTime >= rollDuration) {
                clearInterval(interval);
                return;
            }
            var pos = getRandomPosition(dieSize, dieSize);
            currentRotationX += Math.random() * 360;
            currentRotationY += Math.random() * 360;
            currentRotationZ += Math.random() * 360;
            dieElement.css({
                'left': pos.left + 'px',
                'top': pos.top + 'px',
                'transform': 'rotateX(' + currentRotationX + 'deg) rotateY(' + currentRotationY + 'deg) rotateZ(' + currentRotationZ + 'deg)'
            });
        }, intervalTime);
    }
    animateSync(dieOne);
    animateSync(dieTwo);
    setTimeout(function() {

        var die1Value = e.die1;
        var die2Value = e.die2;
        var totalRoll = die1Value + die2Value;

        // $.post(`https://frkn-prison/rollResult`, JSON.stringify({
        //     die1: die1Value,
        //     die2: die2Value
        // }));


        updateDiceDisplay(dieOne, die1Value);
        updateDiceDisplay(dieTwo, die2Value);
        var finalPos1 = getRandomPosition(dieSize, dieSize);
        var finalPos2 = getRandomPosition(dieSize, dieSize);
        var minDistance = dieSize * 0.8;
        var maxAttempts = 10;
        var attempts = 0;
        while (attempts < maxAttempts) {
            var dist = Math.sqrt(Math.pow(finalPos1.left - finalPos2.left, 2) + Math.pow(finalPos1.top - finalPos2.top, 2));
            if (dist < minDistance) {
                finalPos2 = getRandomPosition(dieSize, dieSize);
                attempts++;
            } else {
                break;
            }
        }
        dieOne.css({
            'left': finalPos1.left + 'px',
            'top': finalPos1.top + 'px',
            'transform': 'rotateX(0deg) rotateY(0deg) rotateZ(0deg)',
            'transition': 'transform 0.5s ease-out, left 0.5s ease-out, top 0.5s ease-out'
        });
        dieTwo.css({
            'left': finalPos2.left + 'px',
            'top': finalPos2.top + 'px',
            'transform': 'rotateX(0deg) rotateY(0deg) rotateZ(0deg)',
            'transition': 'transform 0.5s ease-out, left 0.5s ease-out, top 0.5s ease-out'
        });
        
        updateScoresAndTurn(totalRoll);

        if (round > maxRounds) {
            declareWinner();
        } else {
            rollButton.prop('disabled', false).text('Roll Dice');
        }
    }, rollDuration);
}


function openDice(e) {
    $('.app-container, .container ,  .prisoner-widget-container').fadeOut(150).css('display', 'none');
    $('.casino-widget-container , body').fadeIn(150).css('display', 'flex');

    player1 = e.players.me.name;
    player2 = e.players.opponent.name;

    player1Data = e.players.me;
    player2Data = e.players.opponent;

    currentPlayer = (e.firstTurnId === e.players.me.id) ? player1 : player2;

    player1Score = 0;
    player2Score = 0;
    round = 1;
    maxRounds = e.rounds || 3;

    $('.left-player').text(player1);
    $('.right-player').text(player2);


    if (currentPlayer === player1) {
        rollButton.prop('disabled', false).css({
            'opacity': 1,
            'cursor': 'pointer'
        }).text('Roll Dice');
    } else {
        rollButton.prop('disabled', true).css({
            'opacity': 0.5,
            'cursor': 'not-allowed'
        }).text('Wait...');
    }

    player1ScoreElement.text('Score: ' + player1Score);
    player2ScoreElement.text('Score: ' + player2Score);
    player2ScoreElement.text('Round: ' + round + ' / ' + maxRounds);

    rollButton.prop('disabled', false).text('Roll Dice');

    updateDiceDisplay(dieOne, 4);
    updateDiceDisplay(dieTwo, 4);
    dieOne.css({
        'left': 'calc(50% - ' + (dieSize + 10) + 'px)',
        'top': '50%',
        'transform': 'translateY(-50%)'
    });
    dieTwo.css({
        'left': 'calc(50% + 10px)',
        'top': '50%',
        'transform': 'translateY(-50%)'
    });

    $('.casino-winner-text').hide().css({
        'opacity': 0,
        'transform': 'scale(0.5) translateY(20px)'
    });
}


function visitMenu(data) {
    // $('.app-container, .container , .main-widget-container').fadeOut(150).css('display', 'none');
    $('.prisoner-widget-container , body').fadeIn(150).css('display', 'flex');

    $('.prisoner-list').empty();

    const now = new Date();
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    $('.prisoner-widget-timer-value').text(`${hours}:${minutes}`);


    jailedPlayers = data.jailedPlayers || [];

    if (jailedPlayers) {
        $.each(jailedPlayers, function(index, player) {
            const listItem = `
                <li class="prisoner-list-item" data-record-id="${player.id}" data-player-id="${player.player_id}">
                    <div class="prisoner-name-section">
                        <span class="prisoner-name">${player.player_name}</span> 
                        <span class="prisoner-id">[ID: ${player.player_id}]</span>
                    </div>
                    <button class="prisoner-visit-button">Request Visit</button>
                </li>
            `;
            $('.prisoner-list').append(listItem);
        });
    } else {
        $('.prisoner-list').append('<li class="no-prisoners">There is no one to visit in prison..</li>');
    }
}

function handleVisitResponse(data) {
    const statusMessage = $('.visit-status-message');


    if (data.success) {
        statusMessage.text(`Your visit request has been accepted! You can visit now..`).css('color', 'lightgreen').fadeIn(200);
    } else {
        statusMessage.text(`Your visit request has been denied. It is not appropriate at this time..`).css('color', 'red').fadeIn(200);
    }

    setTimeout(() => {
        statusMessage.fadeOut(500);
        $('.prisoner-widget-container').fadeOut(150).css('display', 'none');
        $.post('https://frkn-prison/closeJailUI', JSON.stringify({}));
    }, 5000); 
}

function visitRequestResponse(data) {
    $('.dialog-widget-container').fadeIn(150).css('display', 'flex');
    $('.dialog-widget-prisoner-name').html(`${data.sender}</span> <span class="dialog-widget-prisoner-id">[ID: ${data.senderId}]`)   
    visitSenderId = data.senderId;
}

$(document).on('click', '.dialog-widget-accept-button', function() {
    $.post('https://frkn-prison/visitControl', JSON.stringify({
        visitSenderId: visitSenderId,
        success: true
    }));

    $('.dialog-widget-container').fadeOut(150).css('display', 'none');
})

$(document).on('click', '.dialog-widget-reject-button', function() {
    $.post('https://frkn-prison/visitControl', JSON.stringify({
        visitSenderId: visitSenderId,
        success: false
    }));
    $('.dialog-widget-container').fadeOut(150).css('display', 'none');
})


$(document).on('click', '.prisoner-visit-button', function() {
    $.post('https://frkn-prison/requestVisit', JSON.stringify({
        recordId: $(this).closest('.prisoner-list-item').data('record-id'),
        playerId: $(this).closest('.prisoner-list-item').data('player-id')
    }));

})


let countdownInterval;

function closeJailMenu(){
    $('.main-widget-container').fadeOut(150).css('display', 'none');
}

function jailmenu(data) {
    // $('.app-container, .container').fadeOut(150).css('display', 'none');
    $('.main-widget-container , body').fadeIn(150).css('display', 'flex');
    

    const pData = data.pData;

    if (countdownInterval) {
        clearInterval(countdownInterval);
    }

    let remainingSeconds = (pData.duration || 0) * 60;
    
    seconds = 60000 - pData.total_seconds
    const firstTwoDigits = Math.floor(seconds / 1000);
    

    const originalDurationSeconds = remainingSeconds;
    const updateTimerAndProgressBar = () => {
        const hours = String(Math.floor(remainingSeconds / 3600)).padStart(2, '0');
        const minutes = String(Math.floor((remainingSeconds % 3600) / 60)).padStart(2, '0')-1;
        const seconds = String(remainingSeconds % 60).padStart(2, '0');


        $('.main-widget-timer').text(`${hours}:${minutes}:${firstTwoDigits}`);

        const progressPercentage = (1 - (remainingSeconds / originalDurationSeconds)) * 100;

        if ($('.main-widget-progress-bar-wrapper').find('.main-widget-progress-bar-inner').length === 0) {
            $('.main-widget-progress-bar-wrapper').html('<div class="main-widget-progress-bar-inner"></div>');
        }

        $('.main-widget-progress-bar-inner').css('width', `${Math.max(0, Math.min(100, progressPercentage))}%`);

        if (remainingSeconds <= 0) {
            clearInterval(countdownInterval);
            // $.post('https://frkn-prison/closeJailMenu', JSON.stringify({}));
        } else {
            remainingSeconds--;
        }
    };

    updateTimerAndProgressBar();
    countdownInterval = setInterval(updateTimerAndProgressBar, 1000);

    const taskListContainer = $('.main-widget-task-list');
    taskListContainer.empty();

    if (pData.tasks_data && pData.tasks_data.length > 0) {
        pData.tasks_data.forEach(task => {
            let taskClass = '';
            if (task.severity === 'High') taskClass = 'main-widget-task-red';
            else if (task.severity === 'Medium') taskClass = 'main-widget-task-blue';
            else if (task.severity === 'Low') taskClass = 'main-widget-task-green';

            const taskItem = `
                <div class="main-widget-task-item ${taskClass}">
                    <span class="main-widget-task-name">${task.name}</span>
                    <span class="main-widget-task-count">${task.currentCount}/${task.targetCount}</span>
                </div>
            `;
            taskListContainer.append(taskItem);
        });
        updateProgressBar();
    } else {
        taskListContainer.append(`
            <div class="main-widget-task-item">
                <span class="main-widget-task-name" style="text-align: center; width: 100%;">No tasks assigned.</span>
            </div>
        `);
    }
}




function openJailMenu(data) {
    $('.app-container , .main-widget-container').fadeOut(150).css('display', 'none');
    $('.container,body').fadeIn(150).css('display', 'flex');

    const playerListContainer = $('.player-list');
    playerListContainer.empty(); 

    if (data.nearbyPlayers && data.nearbyPlayers.length > 0) {
        data.nearbyPlayers.forEach(function(player, index) {
            const playerCard = `
                <div class="player-card ${index === 0 ? 'active' : ''}" data-player-photo="${player.photo}" data-player-id="${player.id}" data-player-identifier="${player.identifier}">
                    <img src="../html/images/face.png" alt="">
                    <div class="player-info">
                        <div class="name">${player.name}</div>
                        <div class="role">${player.job}</div>
                    </div>
                </div>
            `;
            playerListContainer.append(playerCard);
        });
        if (data.nearbyPlayers.length > 0) {
            playerListContainer.find('.player-card').first().addClass('active');
        }
    } else {
        playerListContainer.append('<div class="no-players">No players found nearby.</div>');
    }
}

$(document).on('click', '.confirm-button', function() {
    const selectedPlayerCard = $('.player-card.active');
    const playerName = selectedPlayerCard.find('.name').text();
    const playerRole = selectedPlayerCard.find('.role').text();
    const playerIdentifier = selectedPlayerCard.data('player-identifier');
    const playerId = selectedPlayerCard.data('player-id');
    const playerPhoto = selectedPlayerCard.data('player-photo');

    const crimeType = $('.crime-type.selected .label').text();

    let severity = '';
    $('.severity-levels span').each(function() {
        const borderColor = $(this).css('border-bottom-color');
        if (borderColor.includes('rgba') && borderColor.endsWith(', 0)')) {
        } else if (borderColor.includes('rgb') || (borderColor.includes('rgba') && !borderColor.endsWith(', 0)'))) {
            severity = $(this).text();
            return false; 
        }
    });

    const jailTime = $('.time-input').val();
    const notes = $('.notes-input').val();

    $.post('https://frkn-prison/jailPlayer', JSON.stringify({
        playerName: playerName,
        playerRole: playerRole,
        playerIdentifier: playerIdentifier,
        playerId: playerId,
        crimeType: crimeType,
        severity: severity, 
        jailTime: jailTime,
        notes: notes,
        playerPhoto: playerPhoto
    }));

    $('body').fadeOut(150);
    $.post('https://frkn-prison/closeJailUI', JSON.stringify({}));
});




function openJailList(data) {
    $('.container').css('display', 'none');
    $('.app-container,body').fadeIn(150).css('display', 'flex');
    const tableBody = $('.table-body');
    tableBody.empty();

    if (data.cacheData && data.cacheData.length > 0) {
        data.cacheData.forEach(function(record, index) {
            if (record.status === 1) {
                const jailedTimestamp = record.timestamp;
                const durationMinutes = record.duration;

                const now = Math.floor(Date.now() / 1000);
                const jailStartTime = Math.floor(jailedTimestamp / 1000);
                const jailEndTime = jailStartTime + (durationMinutes * 60);

                let timeLeftText = "Free";
                if (now < jailEndTime) {
                    let remainingSeconds = jailEndTime - now;
                    let days = Math.floor(remainingSeconds / (3600 * 24));
                    remainingSeconds %= (3600 * 24);
                    let hours = Math.floor(remainingSeconds / 3600);
                    remainingSeconds %= 3600;
                    let minutes = Math.floor(remainingSeconds / 60);
                    let seconds = remainingSeconds % 60;

                    let parts = [];
                    if (days > 0) parts.push(`${days} day${days > 1 ? 's' : ''}`);
                    if (hours > 0) parts.push(`${hours} hour${hours > 1 ? 's' : ''}`);
                    if (minutes > 0) parts.push(`${minutes} minute${minutes > 1 ? 's' : ''}`);
                    if (seconds > 0 && days === 0 && hours === 0 && minutes === 0) parts.push(`${seconds} second${seconds > 1 ? 's' : ''}`);

                    timeLeftText = parts.length > 0 ? parts.join(', ') + ' left' : 'Less than a minute left';
                } else {
                    timeLeftText = "Free";
                }

                const crimeMainType = record.reason.split(' (')[0];
                const notesFull = record.reason.split(' (')[1];
                const notesCleaned = notesFull ? notesFull.slice(0, -1) : 'No notes available.';

              const photo = record.player_photo || record.playerPhoto || '';

              console.log('Photo URL:', photo);

              const tableRow = `
                  <div class="table-row"
                      data-id="${record.id}"
                      data-player-id="${record.player_id}"
                      data-player-name="${record.player_name}"
                      data-duration="${record.duration}"
                      data-reason-full="${record.reason}"
                      data-crime-type="${crimeMainType}"
                      data-notes="${notesCleaned}"
                      data-severity="${record.severity}"
                      data-respect="${record.respect}"
                      data-timestamp="${record.timestamp}"
                      data-status="${record.status}"
                      data-photo="${photo}"
                  >
                        <span class="row-item name-col">${record.player_name}</span>
                        <span class="row-item id-col">${record.id}</span>
                        <span class="row-item time-left-col">${timeLeftText}</span>
                        <span class="row-item crime-type-col">${crimeMainType}</span>
                    </div>
                `;
                tableBody.append(tableRow);
            }
        });
    } else {
        tableBody.append('<div class="table-row no-records"><span class="row-item" style="grid-column: 1 / -1; text-align: center; padding: 20px;">No jail records found.</span></div>');
    }
}

$(document).keyup(function(e) {
    if (e.key === "Escape") {
        $('body').fadeOut();
        $.post('https://frkn-prison/closeJailUI', JSON.stringify({}));
    }
});


let currentPower = 0;
let isCharging = false;

window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.action === "showPowerBar") {
        document.getElementById('power-container').style.display = 'block';
        isCharging = true;
        currentPower = data.power || 0;
        updatePowerFill();
    }

    if (data.action === "hidePowerBar") {
        document.getElementById('power-container').style.display = 'none';
        isCharging = false;
        currentPower = 0;
        updatePowerFill();
    }

    if (data.action === "updatePower") {
        currentPower = data.power;
        updatePowerFill();
    }


});

function updatePowerFill() {

    const fill = document.getElementById('power-fill');
    fill.style.width = Math.min(currentPower * 50, 100) + '%';
}




$(document).on('click', '.player-card', function() {
    $('.player-card').removeClass('active')
    $(this).addClass('active')
})

$(document).on('click', '.severity-levels span', function() {
    $('.severity-levels span').each(function() {
        const base = $(this).attr('class').split(' ')[0]
        if (base) {
            $(this).css('border-bottom-color', getRGBA(base, 0))
        }
    })

    const clicked = $(this).attr('class').split(' ')[0]
    $(this).css('border-bottom-color', getRGBA(clicked, 1))
})

function getRGBA(type, alpha) {
    switch (type) {
        case 'low':
            return `rgba(110, 255, 110, ${alpha})`
        case 'medium':
            return `rgba(255, 193, 7, ${alpha})`
        case 'high':
            return `rgba(255, 77, 77, ${alpha})`
        default:
            return 'transparent'
    }
}

$(document).on('click', '.crime-type', function() {
    $('.crime-options').slideToggle(150)
})

$(document).on('click', '.crime-option', function() {
    const selectedText = $(this).text()
    $('.crime-type .label').text(selectedText)
    $('.crime-options').slideUp(150)
})

$(document).on('click', '.app-container .table-row', function() {
    $('.app-container .table-row').removeClass('active');
    $(this).addClass('active');

    const selectedRecord = {
        id: $(this).data('id'),
        player_id: $(this).data('playerId'),
        player_name: $(this).data('playerName'),
        duration: $(this).data('duration'),
        reason: $(this).data('reasonFull'),
        crime_type: $(this).data('crimeType'), 
        notes: $(this).data('notes'),
        severity: $(this).data('severity'),
        respect: $(this).data('respect'),
        timestamp: $(this).data('timestamp'),
        status: $(this).data('status'),
        player_photo: $(this).data('photo') || ''
    };

    if (selectedRecord) {
        $('.prisoner-details-section h2').text(selectedRecord.player_name ? selectedRecord.player_name.toUpperCase() : selectedRecord.player_id.toUpperCase());
        $('.prisoner-details-section .crime-type').text(selectedRecord.crime_type.toUpperCase());

        $('.prisoner-image-placeholder img').attr('src', selectedRecord.player_photo || '../html/images/face.png');

        const jailedTimestamp = selectedRecord.timestamp;
        const durationMinutes = selectedRecord.duration;

        const now = Math.floor(Date.now() / 1000);
        const jailStartTime = Math.floor(jailedTimestamp / 1000);
        const jailEndTime = jailStartTime + (durationMinutes * 60);

        let timeRemainingText = "Released";
        if (now < jailEndTime) {
            let remainingSeconds = jailEndTime - now;
            let days = Math.floor(remainingSeconds / (3600 * 24));
            remainingSeconds %= (3600 * 24);
            let hours = Math.floor(remainingSeconds / 3600);
            remainingSeconds %= 3600;
            let minutes = Math.floor(remainingSeconds / 60);
            let seconds = remainingSeconds % 60;

            let parts = [];
            if (days > 0) parts.push(`${days} day${days > 1 ? 's' : ''}`);
            if (hours > 0) parts.push(`${hours} hour${hours > 1 ? 's' : ''}`);
            if (minutes > 0) parts.push(`${minutes} minute${minutes > 1 ? 's' : ''}`);
            if (seconds > 0 && days === 0 && hours === 0 && minutes === 0) parts.push(`${seconds} second${seconds > 1 ? 's' : ''}`);

            timeRemainingText = parts.length > 0 ? parts.join(', ') + ' left' : 'Less than a minute left';
        }

        $('.prisoner-details-section .time-remaining').text(timeRemainingText);

        $('.prisoner-details-section .notes-text').text(selectedRecord.notes);

        $('.release-prisoner-button').data('id', selectedRecord.id);
        $('.release-prisoner-button').data('player-id', selectedRecord.player_id);

    } else {
        $('.prisoner-details-section h2').text('N/A');
        $('.prisoner-details-section .crime-type').text('N/A');
        $('.prisoner-details-section .time-remaining').text('N/A');
        $('.prisoner-details-section .notes-text').text('No record selected or found.');
        $('.release-prisoner-button').removeData('id').removeData('player-id');
    }
});

$(document).on('click', '.release-prisoner-button', function() {
    const prisonerId = $(this).data('id');
    const playerId = $(this).data('player-id');

    if (prisonerId && playerId) {
        $.post('https://frkn-prison/releasePrisoner', JSON.stringify({
            prisonerId: prisonerId,
            playerId: playerId
        }));
    } else {
        console.error("No prisoner ID or player ID found.");
    }
});

$(document).on('click', 'app-container .filter-label', function() {
    var $clickedLabel = $(this);
    var sortBy = $clickedLabel.data('sort');
    var $tableRows = $('.app-container .prisoner-table-container .table-row');
    var currentDirection = $clickedLabel.hasClass('asc') ? 'desc' : 'asc';
    $('.app-container .filter-label').removeClass('asc desc');
    $clickedLabel.addClass(currentDirection);
    $tableRows.sort(function(a, b) {
        var valA, valB;
        if (sortBy === 'time-left') {
            valA = $(a).find('.time-left-col').text();
            valB = $(b).find('.time-left-col').text();
        } else if (sortBy === 'cell') {
            valA = $(a).find('.crime-type-col').text();
            valB = $(b).find('.crime-type-col').text();
        } else {
            return 0;
        }
        if (currentDirection === 'asc') {
            return valA.localeCompare(valB);
        } else {
            return valB.localeCompare(valA);
        }
    }).appendTo('.app-container .prisoner-table-container');
});


$('.app-container .search-input-wrapper input[type="text"]').on('keyup', function() {
    var searchText = $(this).val().toLowerCase();

    $('.app-container .prisoner-table-container .table-row').each(function() {
        var name = $(this).find('.name-col').text().toLowerCase();

        if (name.includes(searchText)) {
            $(this).show();
        } else {
            $(this).hide();
        }
    });
});


function updateProgressBar() {
    const progressBarWrapper = $('.main-widget-progress-bar-wrapper');
    progressBarWrapper.empty();
    let totalPossibleUnits = 0;
    const taskProgressData = [];
    $('.main-widget-task-item').each(function() {
        const $taskItem = $(this);
        const $taskCount = $taskItem.find('.main-widget-task-count');
        const statusText = $taskCount.text();
        const parts = statusText.split('/');
        const completed = parseInt(parts[0]);
        const total = parseInt(parts[1]);
        if (!isNaN(completed) && !isNaN(total) && total > 0) {
            totalPossibleUnits += total;
            let segmentColor = '';
            let taskColorForCount = '#AAAAAA';
            if ($taskItem.hasClass('main-widget-task-red')) {
                segmentColor = '#E74C3C';
                if (completed === total) {
                    taskColorForCount = '#E74C3C';
                }
            } else if ($taskItem.hasClass('main-widget-task-blue')) {
                segmentColor = '#3498DB';
                if (completed === total) {
                    taskColorForCount = '#3498DB';
                }
            } else if ($taskItem.hasClass('main-widget-task-green')) {
                segmentColor = '#2ECC71';
                if (completed === total) {
                    taskColorForCount = '#2ECC71';
                }
            }

            $taskCount.css('color', taskColorForCount);
            taskProgressData.push({
                completed: completed,
                color: segmentColor
            });
            if (completed === total) {
                $taskItem.addClass('task-fully-completed');
            } else {
                $taskItem.removeClass('task-fully-completed');
            }
        } else {
            $taskItem.removeClass('task-fully-completed');
            $taskCount.css('color', '#AAAAAA');
        }
    });
    let filledOverallPercentage = 0;
    if (totalPossibleUnits > 0) {
        taskProgressData.forEach(task => {
            const taskContributionPercentage = (task.completed / totalPossibleUnits) * 100;
            filledOverallPercentage += taskContributionPercentage;
            const segmentDiv = $('<div></div>')
                .addClass('main-widget-dynamic-progress-segment')
                .css({
                    'width': `${taskContributionPercentage}%`,
                    'background-color': task.color
                });
            progressBarWrapper.append(segmentDiv);
        });
        const remainingPercentage = 100 - filledOverallPercentage;
        if (remainingPercentage > 0) {
            const remainingDiv = $('<div></div>')
                .addClass('main-widget-dynamic-progress-segment')
                .css({
                    'width': `${remainingPercentage}%`,
                    'background-color': 'transparent'
                });
            progressBarWrapper.append(remainingDiv);
        }
    } else {
        const emptyBar = $('<div></div>')
            .addClass('main-widget-dynamic-progress-segment')
            .css({
                'width': '100%',
                'background-color': '#333333'
            });
        progressBarWrapper.append(emptyBar);
    }
}









var progressBoxesContainer = $('.progress-boxes');
var totalBoxes = 25;
var filledBoxes = 0;
var decayRateBoxes = 0.1;
var decayInterval;
var lastPressTime = Date.now();
var decayThreshold = 100;
var gainPerPress = 1;

var isMinigameActive = false;
for (let i = 0; i < totalBoxes; i++) {
    progressBoxesContainer.append('<div class="box-item" data-index="' + i + '"></div>');
}
var boxItems = $('.box-item');


function startDigGame() {
    filledBoxes = 0;
    boxItems.removeClass('filled');
    $('.minigame-inner h1').text('DIG TUNNEL');
    // $('.description').show().text('Lorem Ipsum is simply dummy text of the printing and typesetting industry.');
    $('.press-here-button').text('Click Here').css('background-color', 'rgba(49, 92, 82, 0.43)').css('color', '#6CFFDD').show();
    $('.minigame-wrapper').show();
    isMinigameActive = true;
    lastPressTime = Date.now();
    $('.press-here-button').off('click.minigame').on('click.minigame', function() {
        if (isMinigameActive) {
            lastPressTime = Date.now();
            increaseProgress();
        }
    });
    startDecay();
}

function increaseProgress() {
    if (filledBoxes < totalBoxes) {
        filledBoxes += gainPerPress;
        if (filledBoxes > totalBoxes) {
            filledBoxes = totalBoxes;
        }
        updateBoxes();
        if (filledBoxes === totalBoxes) {
            gameWon();
        }
    }
}

function updateBoxes() {
    boxItems.each(function(index) {
        if (index < filledBoxes) {
            $(this).addClass('filled');
        } else {
            $(this).removeClass('filled');
        }
    });
}

function startDecay() {
    clearInterval(decayInterval);
    decayInterval = setInterval(function() {
        if (isMinigameActive && (Date.now() - lastPressTime > decayThreshold)) {
            if (filledBoxes > 0) {
                filledBoxes -= decayRateBoxes;
                if (filledBoxes < 0) {
                    filledBoxes = 0;
                }
                updateBoxes();
            }
        }
    }, 16);
}

function gameWon() {
    isMinigameActive = false;
    $(document).off('keydown.minigame');
    $('.press-here-button').off('click.minigame');
    clearInterval(decayInterval);
    // $('.description').hide();
    $('.press-here-button').text('SUCCESS!').css('background-color', '#009966').css('color', '#FFFFFF');


    $('.minigame-inner').css('left', '30%').animate({
        left: '70%'
    }, 500); 


    setTimeout(function() {
        $('.minigame-wrapper').hide();
    }, 1500);

    $.post('https://frkn-prison/digGameSuccess', JSON.stringify({}));

}
// $('.minigame-wrapper').hide();

// startDigGame();




let position = 0;
let speed = 2;
let gameActive = true;

function updateDot() {
    if (!gameActive) return;

    position += speed;
    if (position >= 490) position = 490;

    $('#playerDot').css('left', position + 'px');
    requestAnimationFrame(updateDot);
}

$(document).keydown(function(e) {
    if (!gameActive) return;

    if (e.code === 'ArrowRight') {
        position += 5;
    } else if (e.code === 'ArrowLeft') {
        position -= 5;
    } else if (e.code === 'Space') {
        gameActive = false;

        if (position >= 450 && position <= 500) {
            $('#result').text('BAŞARILI! Kapı açıldı.');
        } else {
            $('#result').text('HATA! Yanlış yerde durdun.');
        }
    }

    // Kenarlara taşma engeli
    if (position < 0) position = 0;
    if (position > 490) position = 490;

    $('#playerDot').css('left', position + 'px');
});

updateDot();


function updateDiceDisplay(dieElement, value) {
    dieElement.empty();
    if (value === 1) {
        dieElement.append('<div class="dot center"></div>');
    } else if (value === 2) {
        dieElement.append('<div class="dot top-left"></div><div class="dot bottom-right"></div>');
    } else if (value === 3) {
        dieElement.append('<div class="dot top-left"></div><div class="dot center"></div><div class="dot bottom-right"></div>');
    } else if (value === 4) {
        dieElement.append('<div class="dot top-left"></div><div class="dot top-right"></div><div class="dot bottom-left"></div><div class="dot bottom-right"></div>');
    } else if (value === 5) {
        dieElement.append('<div class="dot top-left"></div><div class="dot top-right"></div><div class="dot center"></div><div class="dot bottom-left"></div><div class="dot bottom-right"></div>');
    } else if (value === 6) {
        dieElement.append('<div class="dot top-left"></div><div class="dot top-right"></div><div class="dot middle-left"></div><div class="dot middle-right"></div><div class="dot bottom-left"></div><div class="dot bottom-right"></div>');
    }
}

function getRandomPosition(dieWidth, dieHeight) {
    var maxX = circleWidth - dieWidth;
    var maxY = circleHeight - dieHeight;
    var randomX = Math.random() * maxX;
    var randomY = Math.random() * maxY;
    var centerX = circleWidth / 2;
    var centerY = circleHeight / 2;
    var radius = circleWidth / 2;
    var dist = Math.sqrt(Math.pow(randomX + dieWidth / 2 - centerX, 2) + Math.pow(randomY + dieHeight / 2 - centerY, 2));
    if (dist + dieWidth / 2 > radius) {
        var angle = Math.random() * 2 * Math.PI;
        var newRadius = Math.random() * (radius - dieWidth / 2);
        randomX = centerX + newRadius * Math.cos(angle) - dieWidth / 2;
        randomY = centerY + newRadius * Math.sin(angle) - dieHeight / 2;
    }
    return {
        left: randomX,
        top: randomY
    };
}

function updateScoresAndTurn(totalRoll) {
    if (currentPlayer === player1) {
        player1Score += totalRoll;
        player1ScoreElement.text('Score: ' + player1Score);
        currentPlayer = player2;

        sendData = player2Data;

        rollButton.prop('disabled', true).css({
            'opacity': 0.5,
            'cursor': 'not-allowed'
        }).text('Wait...');
    } else {
        player2Score += totalRoll;
        player2ScoreElement.text('Score: ' + player2Score);
        currentPlayer = player1;

        sendData = player1Data;

        round++;

        rollButton.prop('disabled', true).css({
            'opacity': 0.5,
            'cursor': 'not-allowed'
        }).text('Wait...');
    }

    player2ScoreElement.text('Round: ' + round + ' / ' + maxRounds);

    $.post('https://frkn-prison/switchTurn', JSON.stringify({ sendData }));
}


function declareWinner() {
    var winnerText = '';
    // if (player1Score > player2Score) {
    //     winnerText = player1 + ' Wins!';
    // } else if (player2Score > player1Score) {
    //     winnerText = player2 + ' Wins!';
    // } else {
    //     winnerText = 'It\'s a Draw!';
    // }
    $('.casino-winner-text').text(winnerText).show().css({
        'opacity': 1,
        'transform': 'scale(1) translateY(0)'
    });
    rollButton.prop('disabled', true).text('Game Over!');
}

function rollDice() {
    if (round > maxRounds) {
        declareWinner();
        return;
    }

    rollButton.prop('disabled', true).text('Zarlar Atılıyor...');
    $('.casino-winner-text').hide().css({
        'opacity': 0,
        'transform': 'scale(0.5) translateY(20px)'
    });
    dieOne.empty();
    dieTwo.empty();

    var rollDuration = 1000;
    var intervalTime = 50;
    var startTime = Date.now();

    function animateDie(dieElement) {
        var currentRotationX = 0;
        var currentRotationY = 0;
        var currentRotationZ = 0;
        var interval = setInterval(function() {
            if (Date.now() - startTime >= rollDuration) {
                clearInterval(interval);
                return;
            }
            var pos = getRandomPosition(dieSize, dieSize);
            currentRotationX += Math.random() * 360;
            currentRotationY += Math.random() * 360;
            currentRotationZ += Math.random() * 360;
            dieElement.css({
                'left': pos.left + 'px',
                'top': pos.top + 'px',
                'transform': 'rotateX(' + currentRotationX + 'deg) rotateY(' + currentRotationY + 'deg) rotateZ(' + currentRotationZ + 'deg)'
            });
        }, intervalTime);
    }
    animateDie(dieOne);
    animateDie(dieTwo);
    setTimeout(function() {
        var die1Value = Math.floor(Math.random() * 6) + 1;
        var die2Value = Math.floor(Math.random() * 6) + 1;
        var totalRoll = die1Value + die2Value;

        $.post(`https://frkn-prison/rollResult`, JSON.stringify({
            die1: die1Value,
            die2: die2Value
        }));


        updateDiceDisplay(dieOne, die1Value);
        updateDiceDisplay(dieTwo, die2Value);
        var finalPos1 = getRandomPosition(dieSize, dieSize);
        var finalPos2 = getRandomPosition(dieSize, dieSize);
        var minDistance = dieSize * 0.8;
        var maxAttempts = 10;
        var attempts = 0;
        while (attempts < maxAttempts) {
            var dist = Math.sqrt(Math.pow(finalPos1.left - finalPos2.left, 2) + Math.pow(finalPos1.top - finalPos2.top, 2));
            if (dist < minDistance) {
                finalPos2 = getRandomPosition(dieSize, dieSize);
                attempts++;
            } else {
                break;
            }
        }
        dieOne.css({
            'left': finalPos1.left + 'px',
            'top': finalPos1.top + 'px',
            'transform': 'rotateX(0deg) rotateY(0deg) rotateZ(0deg)',
            'transition': 'transform 0.5s ease-out, left 0.5s ease-out, top 0.5s ease-out'
        });
        dieTwo.css({
            'left': finalPos2.left + 'px',
            'top': finalPos2.top + 'px',
            'transform': 'rotateX(0deg) rotateY(0deg) rotateZ(0deg)',
            'transition': 'transform 0.5s ease-out, left 0.5s ease-out, top 0.5s ease-out'
        });
        
        updateScoresAndTurn(totalRoll);

        if (round > maxRounds) {
            declareWinner();
        } else {
            rollButton.prop('disabled', false).text('Roll Dice');
        }
    }, rollDuration);
}

$('.casino-roll-button').on('click', function() {
    var opacity = parseFloat($(this).css('opacity'));
    if (opacity >= 1) {
        rollDice();
    }
});
// updateDiceDisplay(dieOne, 4);
// updateDiceDisplay(dieTwo, 4);
// dieOne.css({
//     'left': 'calc(50% - ' + (dieSize + 10) + 'px)',
//     'top': '50%',
//     'transform': 'translateY(-50%)'
// });
// dieTwo.css({
//     'left': 'calc(50% + 10px)',
//     'top': '50%',
//     'transform': 'translateY(-50%)'
// });

// $('.casino-player-left').prepend('<span class="casino-turn-text">His Turn</span>');
// player1ScoreElement.text('Score: ' + player1Score);
// player2ScoreElement.text('Score: ' + player2Score);
// player2ScoreElement.text('Round: ' + round + ' / ' + maxRounds);




async function getBase64Image(src, removeImageBackGround, callback, outputFormat) {
	const img = new Image();
	img.crossOrigin = 'Anonymous';
	img.addEventListener("load", () => loadFunc(), false);
	async function loadFunc() {
		const canvas = document.createElement('canvas');
		const ctx = canvas.getContext('2d');
		var convertingCanvas = canvas;
		if (removeImageBackGround) {
			var selectedSize = 320
			canvas.height = selectedSize;
			canvas.width = selectedSize;
			ctx.drawImage(img, 0, 0, selectedSize, selectedSize);
			await removeBackGround(canvas);
			const canvas2 = document.createElement('canvas');
			const ctx2 = canvas2.getContext('2d');
			canvas2.height = 64;
			canvas2.width = 64;
			ctx2.drawImage(canvas, 0, 0, selectedSize, selectedSize, 0, 0, img.naturalHeight, img.naturalHeight);
			convertingCanvas = canvas2;
		} else {
			canvas.height = img.naturalHeight;
			canvas.width = img.naturalWidth;
			ctx.drawImage(img, 0, 0);
		}
		var dataURL = convertingCanvas.toDataURL(outputFormat);
		canvas.remove();
		convertingCanvas.remove();
		img.remove();
		callback(dataURL);
	};
	img.src = src;
	if (img.complete || img.complete === undefined) {
		img.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACEAAAAkCAIAAACIS8SLAAAAKklEQVRIie3NMQEAAAgDILV/55nBww8K0Enq2XwHDofD4XA4HA6Hw+E4Wwq6A0U+bfCEAAAAAElFTkSuQmCC";
		img.src = src;
	}
}
  

async function Convert(pMugShotTxd, removeImageBackGround, id) {
    var tempUrl = `https://nui-img/${pMugShotTxd}/${pMugShotTxd}?t=${String(Math.round(new Date().getTime() / 1000))}`;
	getBase64Image(tempUrl, removeImageBackGround, function(dataUrl) {
		var xhr = new XMLHttpRequest();
		xhr.open("POST", `https://frkn-prison/Answer`, true);
		xhr.setRequestHeader('Content-Type', 'application/json');
		xhr.send(JSON.stringify({Answer: dataUrl, Id: id,}));
        $('.charbg').attr('src', dataUrl);
	})
}
 

async function removeBackGround(sentCanvas) {
	const canvas = sentCanvas;
	const ctx = canvas.getContext('2d');
	const net = await bodyPix.load({
		architecture: 'MobileNetV1',
		outputStride: 16,
		multiplier: 0.75,
		quantBytes: 2
	});
	const { data:map } = await net.segmentPerson(canvas, {
	  	internalResolution: 'medium',
	});
	const { data:imgData } = ctx.getImageData(0, 0, canvas.width, canvas.height);
	const newImg = ctx.createImageData(canvas.width, canvas.height);
	const newImgData = newImg.data;
	for (var i=0; i<map.length; i++) {
		const [r, g, b, a] = [imgData[i*4], imgData[i*4+1], imgData[i*4+2], imgData[i*4+3]];
		[
		newImgData[i*4],
		newImgData[i*4+1],
		newImgData[i*4+2],
		newImgData[i*4+3]
		] = !map[i] ? [255, 255, 255, 0] : [r, g, b, a];
	}
	ctx.putImageData(newImg, 0, 0);
}
