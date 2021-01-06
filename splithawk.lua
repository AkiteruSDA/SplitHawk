local Commands = {
    START_TIMER = "starttimer",
    START_OR_SPLIT = "startorsplit",
    SPLIT = "split",
    UNSPLIT = "unsplit",
    SKIP_SPLIT = "skipsplit",
    PAUSE = "pause",
    RESUME = "resume",
    RESET = "reset",
    INIT_GAME_TIME = "initgametime",
    SET_GAME_TIME = "setgametime",
    SET_LOADING_TIMES = "setloadingtimes",
    PAUSE_GAME_TIME = "pausegametime",
    UNPAUSE_GAME_TIME = "unpausegametime",
    SET_COMPARISON = "setcomparison",
    GET_DELTA = "getdelta",
    GET_LAST_SPLIT_TIME = "getlastsplittime",
    GET_COMPARISON_SPLIT_TIME = "getcomparisonsplittime",
    GET_CURRENT_TIME = "getcurrenttime",
    GET_FINAL_TIME = "getfinaltime",
    GET_PREDICTED_TIME = "getpredictedtime",
    GET_BEST_POSSIBLE_TIME = "getbestpossibletime",
    GET_SPLIT_INDEX = "getsplitindex",
    GET_CURRENT_SPLIT_NAME = "getcurrentsplitname",
    GET_PREVIOUS_SPLIT_NAME = "getprevioussplitname",
    GET_CURRENT_TIMER_PHASE = "getcurrenttimerphase"
};

local function formatTime(ms, sec, min, hr)
    hr = hr and hr .. ":" or "";
    min = min and min .. ":" or "";
    sec = sec and sec .. "." or "";
    ms = ms or "";
    return hr .. min .. sec .. ms;
end

local function SplitHawk(ip, port)
    local socket = require("socket.core");
    local tcp = assert(socket.tcp());
    tcp:connect(ip or "localhost", port or 16834);

    local function command(key, param)
        param = param and " " .. param or "";
        tcp:send(key .. param .. "\r\n");
    end

    local function set(key, param)
        command(key, param);
    end

    local function get(key, param)
        command(key, param);
        local val = tcp:receive();
        return val;
    end

    local self = {};

    --------------
    -- Commands --
    --------------

    self.startTimer = function()
        set(Commands.START_TIMER);
    end

    self.startOrSplit = function()
        set(Commands.START_OR_SPLIT);
    end

    self.split = function()
        set(Commands.SPLIT);
    end

    self.unsplit = function()
        set(Commands.UNSPLIT);
    end

    self.skipSplit = function()
        set(Commands.SKIP_SPLIT);
    end

    self.pause = function()
        set(Commands.PAUSE);
    end

    self.resume = function()
        set(Commands.RESUME);
    end

    self.reset = function()
        set(Commands.RESET);
    end

    self.initGameTime = function()
        set(Commands.INIT_GAME_TIME);
    end

    self.setGameTime = function(ms, sec, min, hr)
        set(Commands.SET_GAME_TIME, formatTime(ms, sec, min, hr));
    end

    self.setLoadingTimes = function(ms, sec, min, hr)
        set(Commands.SET_LOADING_TIMES, formatTime(ms, sec, min, hr));
    end

    self.pauseGameTime = function()
        set(Commands.PAUSE_GAME_TIME);
    end

    self.unpauseGameTime = function()
        set(Commands.UNPAUSE_GAME_TIME);
    end

    self.setComparison = function(comp)
        set(Commands.SET_COMPARISON, comp);
    end

    ------------------
    -- Time getters --
    ------------------

    self.getDelta = function()
        return get(Commands.GET_DELTA);
    end

    self.getDeltaComparison = function(comp)
        return get(Commands.GET_DELTA, comp);
    end

    self.getLastSplitTime = function()
        return get(Commands.GET_LAST_SPLIT_TIME);
    end

    self.getComparisonSplitTime = function()
        return get(Commands.GET_COMPARISON_SPLIT_TIME);
    end

    self.getCurrentTime = function()
        return get(Commands.GET_CURRENT_TIME);
    end

    self.getFinalTime = function()
        return get(Commands.GET_FINAL_TIME);
    end

    self.getFinalTimeComparison = function(comp)
        return get(Commands.GET_FINAL_TIME, comp);
    end

    self.getPredictedTime = function(comp)
        return get(Commands.GET_PREDICTED_TIME, comp);
    end

    self.getBestPossibleTime = function()
        return get(Commands.GET_BEST_POSSIBLE_TIME);
    end

    -------------------
    -- Other getters --
    -------------------

    self.getSplitIndex = function()
        return get(Commands.GET_SPLIT_INDEX);
    end

    self.getCurrentSplitName = function()
        return get(Commands.GET_CURRENT_SPLIT_NAME);
    end

    self.getPreviousSplitName = function()
        return get(Commands.GET_PREVIOUS_SPLIT_NAME);
    end

    self.getCurrentTimerPhase = function()
        return get(Commands.GET_CURRENT_TIMER_PHASE);
    end

    return self;
end

return SplitHawk;
