// scr_audio
function audio_init() {
    global.bus_music = audio_bus_create();
	global.bus_sfx   = audio_bus_create();

    global.fx_music_lpf = audio_effect_create(AudioEffectType.LPF2, { cutoff: 20000, q: 1 });
    global.bus_music.effects[0] = global.fx_music_lpf;

    global.em_music = audio_emitter_create();
    global.em_sfx   = audio_emitter_create();
    audio_emitter_bus(global.em_music, global.bus_music);
    audio_emitter_bus(global.em_sfx,   global.bus_sfx);

    audio_emitter_gain(global.em_music, sqr(global.opt_music));
    audio_emitter_gain(global.em_sfx,   sqr(global.opt_sfx));

    global.music_h = -1;
}

function music_play(_snd) {
    if (audio_is_playing(global.music_h)) audio_stop_sound(global.music_h);
    global.music_h = audio_play_sound_on(global.em_music, _snd, true, 1);
}

function sfx_play(_snd) {
    return audio_play_sound_on(global.em_sfx, _snd, false, 0);
}