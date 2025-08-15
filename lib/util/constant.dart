/*  현재 시간 RTC 데이터 */
// ignore_for_file: constant_identifier_names

const int FUNC_CODE_SET_CURRENT_RTC = 0x01;

/// 전면 LED 데이터 전송
const int FUNC_CODE_SET_FRONT_LIGHT = 0x02;

/// 후면 LED 데이터 전송
const int FUNC_CODE_SET_BACK_LIGHT = 0x03;

/// 전면 LED 데이터 요청
const int FUNC_CODE_GET_FRONT_LIGHT = 0x04;

/// 후면 LED 데이터 요청
const int FUNC_CODE_GET_BACK_LIGHT = 0x05;

/// 무드등 켜짐 예약 시간 전송
const int FUNC_CODE_SET_SCHEDULED_OFF_TIME = 0x06;

/// 무드등 켜짐 예약 시간 조회
const int FUNC_CODE_GET_SCHEDULED_OFF_TIME = 0x07;

/// Alarm 시간 및 무드등 데이터 설정
const int FUNC_CODE_SET_ALARM_DATA = 0x08;

/// Alarm 시간 및 무드등 데이터 요청
const int FUNC_CODE_GET_ALARM_DATA = 0x09;

/// Alarm 종료
const int FUNC_CODE_STOP_ALARM = 0x0a;

/// Alarm 데이터 삭제
const int FUNC_CODE_DELETE_ALARM = 0x0b;

// 타이머 관련
const int TURN_OFF_TYPE_NONE = 0x00;
const int TURN_OFF_TYPE_SMART = 0x01;
const int TURN_OFF_TYPE_15MIN_LATER = 0x02;
const int TURN_OFF_TYPE_30MIN_LATER = 0x03;
const int TURN_OFF_TYPE_60MIN_LATER = 0x04;
