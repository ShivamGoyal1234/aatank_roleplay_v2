var myPlayTime = 0;
var tasks = [];
var remaining;
var done;
var language = [];

window.addEventListener("message", function (event) {
    var v = event.data;
    switch (v.action) {
        case "show":
            $(".generalDailyTasks").show();
            remaining = v.remaining;
            myPlayTime = v.playTime;
            tasks = v.tasks;
            done = v.done;
            language = v.language;
            setTasks(tasks, v.playerDetails);
            $(".title1").html(language.title1);
            $(".title2").html(language.title2);
            $(".descArea").html(language.description);
            $(".cancelMissionButton").html(language.cancelMission);
            $(".remainingText").html(language.remaining);
            break;
    }
});

$(document).on("keydown", function () {
    switch (event.keyCode) {
        case 27: // ESC
            $.post("https://ak4y-dailyTasks/closeMenu", JSON.stringify());
            $(".generalDailyTasks").hide();
            $(".willPaySection").hide();
            $(".cancelSection").hide();
            break;
    }
});

function setTasks(tasks, playerData) {
    $(".rightAreaTaskSection").empty();
    var selected = false;
    var isBig = false;
    var selectedTaskId = 0;
    var selectedProgress = 0;
    var progressPercent = 0;
    if (typeof playerData != "undefined") {
        selected = true;
        selectedTaskId = playerData.taskId;
        selectedProgress = (playerData.neededPlayTime - myPlayTime) / playerData.neededPlayTime;
        progressPercent = 100 - (myPlayTime / playerData.neededPlayTime) * 100;
        progressPercent = progressPercent.toFixed(0);
    }
    tasks.forEach((element) => {
        var html = ``;
        var typeS = "second";
        if (element.taskId === 3) {
            typeS = "thirt";
        } else if (element.taskId === 4) {
            typeS = "four";
        } else if (element.taskId === 5) {
            typeS = "five";
        } else if (element.taskId === 6) {
            typeS = "six";
        } else if (element.taskId === 7) {
            typeS = "seven";
        } else if (element.taskId === 8) {
            typeS = "eight";
        } else if (element.taskId === 9) {
            typeS = "nine";
        }
        if (!selected) {
            if (element.taskId === 1) {
                html = `
                <div class="taskItem firstTask" id="task-${element.taskId}">
                    <div class="taskItemImageSection first">
                        <img src=${element.image} alt="" />
                    </div>
                    <div class="inTaskLeftArea">
                        <div class="inTaskTitle">${element.name}</div>
                        <div class="inTaskDesc">
                            ${element.description}
                        </div>
                        <div class="inTaskButtonReward">
                            <div class="inButtonRewardText">${language.reward}</div>
                            <div class="inButtonRewardPrice">$${element.reward}</div>
                        </div>
                    </div>
                    <div class="inTaskRightArea">
                        <div class="startMissionButton" data-taskInfo = '${JSON.stringify(element)}'>START MISSION</div>
                        <div class="taskStartPriceText">${language.taskStartPrice}</div>
                        <div class="taskPrice">$${element.taskPrice}</div>
                    </div>
                </div>
                `;
            } else {
                html = `
                <div class="taskItem" id="task-${element.taskId}">
                    <div class="taskItemImageSection ${typeS}">
                        <img src=${element.image} alt="" />
                    </div>
                    <div class="inTaskLeftArea small">
                        <div class="inTaskTitle small">${element.name}</div>
                        <div class="inTaskDesc small">${element.description}</div>
                        <div class="inTaskButtonReward small">
                            <div class="inButtonRewardText small">${language.reward}</div>
                            <div class="inButtonRewardPrice small">$${element.reward}</div>
                        </div>
                    </div>
                    <div class="inTaskRightArea small">
                        <div class="startMissionButton small" data-taskInfo = '${JSON.stringify(element)}'>START MISSION</div>
                        <div class="taskStartPriceText small">${language.taskStartPrice}</div>
                        <div class="taskPrice small">$${element.taskPrice}</div>
                    </div>
                </div>
                `;
            }
        } else {
            if (element.taskId === 1) {
                if (element.taskId === selectedTaskId) {
                    isBig = true;
                    if (done) {
                        html = `
                        <div class="taskItem firstTask" id="task-${element.taskId}">
                            <div class="taskItemImageSection first">
                                <img src=${element.image} alt="" />
                            </div>
                            <div class="inTaskLeftArea">
                                <div class="inTaskTitle">${element.name}</div>
                                <div class="inTaskDesc">
                                    ${element.description}
                                </div>
                                <div class="inTaskButtonReward active">
                                    <div class="inButtonRewardText">${language.reward}</div>
                                    <div class="inButtonRewardPrice">$${element.reward}</div>
                                </div>
                            </div>
                            <div class="inTaskRightArea">
                                <div class="remainingArea small">
                                    <i id="remainingClockIcon" class="fa-solid fa-clock"></i>
                                    <div class="remainingTextArea">
                                        <div class="remainingText">${language.remaining}</div>
                                        <div class="divRemainingTimeText">-</div>
                                    </div>
                                </div>
                                <div class="radialArea">
                                    <div id="progressBarBig"></div>
                                </div>
                                <div class="getRewardButton">${language.getReward}</div>
                            </div>
                        </div>
                        `;
                    } else {
                        html = `
                        <div class="taskItem firstTask" id="task-${element.taskId}">
                            <div class="taskItemImageSection first">
                                <img src=${element.image} alt="" />
                            </div>
                            <div class="inTaskLeftArea">
                                <div class="inTaskTitle">${element.name}</div>
                                <div class="inTaskDesc">
                                    ${element.description}
                                </div>
                                <div class="inTaskButtonReward active">
                                    <div class="inButtonRewardText">${language.reward}</div>
                                    <div class="inButtonRewardPrice">$${element.reward}</div>
                                </div>
                            </div>
                            <div class="inTaskRightArea">
                                <div class="remainingArea small">
                                    <i id="remainingClockIcon" class="fa-solid fa-clock"></i>
                                    <div class="remainingTextArea">
                                        <div class="remainingText">${language.remaining}</div>
                                        <div class="divRemainingTimeText">${remaining}</div>
                                    </div>
                                </div>
                                <div class="radialArea">
                                    <div id="progressBarBig"></div>
                                </div>
                                <div class="cancelMissionButton">${language.cancelMission}</div>
                            </div>
                        </div>
                        `;
                    }
                } else {
                    html = `
                    <div class="taskItem firstTask" id="task-${element.taskId}">
                        <div class="taskItemImageSection first">
                            <img src=${element.image} alt="" />
                        </div>
                        <div class="inTaskLeftArea">
                            <div class="inTaskTitle">${element.name}</div>
                            <div class="inTaskDesc">
                                ${element.description}
                            </div>
                            <div class="inTaskButtonReward">
                                <div class="inButtonRewardText">${language.reward}</div>
                                <div class="inButtonRewardPrice">$${element.reward}</div>
                            </div>
                        </div>
                        <div class="inTaskRightArea">
                            <div class="startMissionButton lock">${language.lock}</div>
                            <div class="taskStartPriceText">${language.taskStartPrice}</div>
                            <div class="taskPrice">$${element.taskPrice}</div>
                        </div>
                    </div>
                    `;
                }
            } else {
                if (element.taskId === selectedTaskId) {
                    isBig = false;
                    if (done) {
                        html = `
                        <div class="taskItem" id="task-${element.taskId}">
                            <div class="taskItemImageSection ${typeS}">
                                <img src=${element.image} alt="" />
                            </div>
                            <div class="inTaskLeftArea small">
                                <div class="inTaskTitle small">${element.name}</div>
                                <div class="inTaskDesc small">${element.description}</div>
                                <div class="inTaskButtonReward small active">
                                    <div class="inButtonRewardText small">${language.reward}</div>
                                    <div class="inButtonRewardPrice small">$${element.reward}</div>
                                </div>
                            </div>
                            <div class="inTaskRightArea small">
                                <div class="remainingArea small">
                                    <i id="remainingClockIcon" class="fa-solid fa-clock"></i>
                                    <div class="remainingTextArea">
                                        <div class="remainingText">${language.remaining}</div>
                                        <div class="divRemainingTimeText">-</div>
                                    </div>
                                </div>
                                <div class="radialArea small">
                                    <div id="progressBarSmall"></div>
                                </div>
                                <div class="getRewardButton small">${language.getReward}</div>
                            </div>
                        </div>
                        `;
                    } else {
                        html = `
                        <div class="taskItem" id="task-${element.taskId}">
                            <div class="taskItemImageSection ${typeS}">
                                <img src=${element.image} alt="" />
                            </div>
                            <div class="inTaskLeftArea small">
                                <div class="inTaskTitle small">${element.name}</div>
                                <div class="inTaskDesc small">${element.description}</div>
                                <div class="inTaskButtonReward small active">
                                    <div class="inButtonRewardText small">${language.reward}</div>
                                    <div class="inButtonRewardPrice small">$${element.reward}</div>
                                </div>
                            </div>
                            <div class="inTaskRightArea small">
                                <div class="remainingArea small">
                                    <i id="remainingClockIcon" class="fa-solid fa-clock"></i>
                                    <div class="remainingTextArea">
                                        <div class="remainingText">${language.remaining}</div>
                                        <div class="divRemainingTimeText">${remaining}</div>
                                    </div>
                                </div>
                                <div class="radialArea small">
                                    <div id="progressBarSmall"></div>
                                </div>
                                <div class="cancelMissionButton small">${language.cancelMission}</div>
                            </div>
                        </div>
                        `;
                    }
                } else {
                    html = `
                    <div class="taskItem" id="task-${element.taskId}">
                        <div class="taskItemImageSection ${typeS}">
                            <img src=${element.image} alt="" />
                        </div>
                        <div class="inTaskLeftArea small">
                            <div class="inTaskTitle small">${element.name}</div>
                            <div class="inTaskDesc small">${element.description}</div>
                            <div class="inTaskButtonReward small">
                                <div class="inButtonRewardText small">${language.reward}</div>
                                <div class="inButtonRewardPrice small">$${element.reward}</div>
                            </div>
                        </div>
                        <div class="inTaskRightArea small">
                            <div class="startMissionButton small lock">${language.lock}</div>
                            <div class="taskStartPriceText small">${language.taskStartPrice}</div>
                            <div class="taskPrice small">$${element.taskPrice}</div>
                        </div>
                    </div>
                    `;
                }
            }
        }
        $(".rightAreaTaskSection").append(html);
    });
    if (selected) {
        if (isBig) {
            createBigProgress();
            taskProgressId1.animate(selectedProgress);
            taskProgressId1.setText(progressPercent + "%");
        } else {
            createSmallProgress();
            taskProgressId2.animate(selectedProgress);
            taskProgressId2.setText(progressPercent + "%");
        }
    }
}

$(document).on("click", ".startMissionButton", function () {
    var selectedDiv = this;
    var infoString = $(selectedDiv).attr("data-taskInfo");
    var parseInfo = JSON.parse(infoString);
    $("#acceptButton").attr("data-taskInfo", infoString);
    $(".payAmount").html("$" + parseInfo.taskPrice);
    $(".willPaySection").fadeIn(200);
});

$(document).on("click", "#acceptButton", function () {
    var infoString = $("#acceptButton").attr("data-taskInfo");
    var parseInfo = JSON.parse(infoString);
    var typeS = "second";
    if (parseInfo.taskId === 3) {
        typeS = "thirt";
    } else if (parseInfo.taskId === 4) {
        typeS = "four";
    } else if (parseInfo.taskId === 5) {
        typeS = "five";
    } else if (parseInfo.taskId === 6) {
        typeS = "six";
    } else if (parseInfo.taskId === 7) {
        typeS = "seven";
    } else if (parseInfo.taskId === 8) {
        typeS = "eight";
    } else if (parseInfo.taskId === 9) {
        typeS = "nine";
    }
    $.post(
        "https://ak4y-dailyTasks/selectTask",
        JSON.stringify({
            itemDetails: parseInfo,
        }),
        function (data) {
            if (data == true) {
                $(".willPaySection").fadeOut(200);
                remaining = "-";
                done = false;
                myPlayTime = parseInfo.neededPlayTime;
                setTasks(tasks, { reward: parseInfo.reward, neededPlayTime: parseInfo.neededPlayTime, taskId: parseInfo.taskId });
            } else {
                $(".notifyMain").html(language.error);
                $(".notifySection").fadeIn(250);
                setTimeout(() => {
                    $(".notifySection").fadeOut(250);
                }, 1500);
            }
        }
    );
});

$(document).on("click", "#cancelMissionButton", function () {
    $.post("https://ak4y-dailyTasks/cancelTask", JSON.stringify({}), function () {
        setTasks(tasks);
        done = false;
    });
    $(".cancelSection").fadeOut(200);
});

$(document).on("click", ".getRewardButton", function () {
    $.post("https://ak4y-dailyTasks/getReward", JSON.stringify({}), function (data) {
        if (data == true) {
            setTasks(tasks);
            done = false;
            $(".collectedMain").html(language.received);
            $(".collectedSection").fadeIn(250);
            setTimeout(() => {
                $(".collectedSection").fadeOut(250);
            }, 1500);
        }
    });
});

$(document).on("click", ".cancelMissionButton", function () {
    $(".cancelSection").fadeIn(200);
});

$(document).on("click", "#cancelButton", function () {
    $(".willPaySection").fadeOut(200);
});

$(document).on("click", "#resumeMissionButton", function () {
    $(".cancelSection").fadeOut(200);
});

function createBigProgress() {
    taskProgressId1 = new ProgressBar.Circle("#progressBarBig", {
        strokeWidth: 7,
        easing: "easeInOut",
        duration: 500,
        color: "#5BFF93",
        trailColor: "#2c2c2c",
        trailWidth: 5,
        text: {
            value: "5/10",
            className: "radialText",
            style: {
                color: "#fff",
                position: "absolute",
                left: "50%",
                top: "50%",
                padding: 0,
                margin: 0,
                transform: {
                    prefix: true,
                    value: "translate(-50%, -50%)",
                },
            },
        },
        fill: "rgba(0, 0, 0, 0.1)",
    });
}
function createSmallProgress() {
    taskProgressId2 = new ProgressBar.Circle("#progressBarSmall", {
        strokeWidth: 7,
        easing: "easeInOut",
        duration: 500,
        color: "#5BFF93",
        trailColor: "#2c2c2c",
        trailWidth: 5,
        text: {
            value: "5/10",
            className: "radialTextSmall",
            style: {
                color: "#fff",
                position: "absolute",
                left: "50%",
                top: "50%",
                padding: 0,
                margin: 0,
                transform: {
                    prefix: true,
                    value: "translate(-50%, -50%)",
                },
            },
        },
        fill: "rgba(0, 0, 0, 0.1)",
    });
}
