//+-------------------------------------------------------------------------------+
//|                                                    Pattern Recognition Master |
//|                                          Copyright © 2010-2022, EarnForex.com |
//| Based on MT4 indicators by: Carl Sanders, Jason Robinson, and Hartono Setiono |
//+-------------------------------------------------------------------------------+
#property copyright "Copyright © 2010-2022, www.EarnForex.com"
#property link      "https://www.earnforex.com/metatrader-indicators/Pattern-Recognition-Master/"
#property version   "1.02"
#property strict

#property description "Recognizes Japanese candlestick patterns."

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 clrYellow
#property indicator_type1  DRAW_ARROW
#property indicator_color2 clrYellow
#property indicator_type2  DRAW_ARROW

// Change it to true if your broker uses extra digit in quotes:
input bool UseExtraDigit = false;

input bool Show_Alert = false;

input bool Display_ShootStar_2 = true;
input bool Show_ShootStar_Alert_2 = true;
input bool Display_ShootStar_3 = true;
input bool Show_ShootStar_Alert_3 = true;
input bool Display_ShootStar_4 = true;
input bool Show_ShootStar_Alert_4 = true;
input color Color_ShootStar = clrRed;
int Text_ShootStar = 8;

input bool Display_Hammer_2 = true;
input bool Show_Hammer_Alert_2 = true;
input bool Display_Hammer_3 = true;
input bool Show_Hammer_Alert_3 = true;
input bool Display_Hammer_4 = true;
input bool Show_Hammer_Alert_4 = true;
input color Color_Hammer = clrBlue;
int Text_Hammer = 8;

input bool Display_Doji = true;
input bool Show_Doji_Alert = true;
input color Color_Doji = clrRed;
int Text_Doji = 8;

input bool Display_Stars = true;
input bool Show_Stars_Alert = true;
input int  Star_Body_Length = 5;
input color Color_Star = clrBlue;
int Text_Star = 8;

input bool Display_Dark_Cloud_Cover = true;
input bool Show_DarkCC_Alert = true;
input color Color_DarkCC = clrRed;
int Text_DarkCC = 8;

input bool Display_Piercing_Line = true;
input bool Show_Piercing_Line_Alert = true;
input color Color_Piercing_Line = clrBlue;
int Text_Piercing_Line = 8;

input bool Display_Bearish_Engulfing = true;
input bool Show_Bearish_Engulfing_Alert = true;
input color Color_Bearish_Engulfing = clrRed;
int Text_Bearish_Engulfing = 8;

input bool Display_Bullish_Engulfing = false;
input bool Show_Bullish_Engulfing_Alert = false;
input color Color_Bullish_Engulfing = clrBlue;
int Text_Bullish_Engulfing = 8;

input string FontFace = "Times New Roman";
input string ObjectPrefix = "PRM-";

double upArrow[];
double downArrow[];

double Doji_Star_Ratio = 0;
double Doji_MinLength = 0;
double Star_MinLength = 0;
int  Pointer_Offset = 0;         // The offset value for the arrow to be located off the candle high or low point.
int  High_Offset = 0;            // The offset value added to the high arrow pointer for correct plotting of the pattern label.
int  Offset_ShootStar = 0;       // The offset value of the shooting star above or below the pointer arrow.
int  Offset_Hammer = 0;          // The offset value of the hammer above or below the pointer arrow.
int  Offset_Doji = 0;            // The offset value of the doji above or below the pointer arrow.
int  Offset_Star = 0;            // The offset value of the star above or below the pointer arrow.
int  Offset_Piercing_Line = 0;   // The offset value of the piercing line above or below the pointer arrow.
int  Offset_DarkCC = 0;          // The offset value of the dark cloud cover above or below the pointer arrow.
int  Offset_Bullish_Engulfing = 0;
int  Offset_Bearish_Engulfing = 0;
int  IncOffset = 0;              // The offset value that is added to a cummulative offset value for each pass through the routine so any
                                 // additional candle patterns that are also met, the label will print above the previous label.
double Piercing_Line_Ratio = 0;
int Piercing_Candle_Length = 0;
int Engulfing_Length = 0;
double Candle_WickBody_Percent = 0;
int CandleLength = 0;

string period;

void OnInit()
{
    SetIndexArrow(0, 72);
    SetIndexBuffer(0, downArrow);

    SetIndexArrow(1, 71);
    SetIndexBuffer(1, upArrow);

    IndicatorSetString(INDICATOR_SHORTNAME, "PRM");

    Comment("\n", "\n", "Bearish",
            "\n", "SS 2,3,4 - Shooting Star",
            "\n", "E_Star   - Evening Star",
            "\n", "E_Doji   - Evening Doji Star",
            "\n", "DCC      - Dark Cloud Pattern",
            "\n", "S_E      - Bearish Engulfing Pattern",
            "\n", "\n", "Bullish",
            "\n", "HMR 2,3,4 - Bullish Hammer",
            "\n", "M_Star    - Morning Star",
            "\n", "M_Doji    - Morning Doji Star",
            "\n", "P_L       - Piercing Line Pattern",
            "\n", "L_E       - Bullish Engulfing Pattern");

    switch (PeriodSeconds(Period()) / 60)
    {
    case 1:
        period = "M1";
        Doji_Star_Ratio = 0;
        Piercing_Line_Ratio = 0.5;
        Piercing_Candle_Length = 10;
        Engulfing_Length = 10;
        Candle_WickBody_Percent = 0.9;
        CandleLength = 12;
        Pointer_Offset = 9;
        High_Offset = 15;
        Offset_Hammer = 5;
        Offset_ShootStar = 5;
        Offset_Doji = 5;
        Offset_Star = 5;
        Offset_Piercing_Line = 5;
        Offset_DarkCC = 5;
        Offset_Bearish_Engulfing = 5;
        Offset_Bullish_Engulfing = 5;
        Text_ShootStar = 8;
        Text_Hammer = 8;
        Text_Star = 8;
        Text_DarkCC = 8;
        Text_Piercing_Line = 8;
        Text_Bearish_Engulfing = 8;
        Text_Bullish_Engulfing = 8;
        IncOffset = 16;
        break;
    case 5:
        period = "M5";
        Doji_Star_Ratio = 0;
        Piercing_Line_Ratio = 0.5;
        Piercing_Candle_Length = 10;
        Engulfing_Length = 10;
        Candle_WickBody_Percent = 0.9;
        CandleLength = 12;
        Pointer_Offset = 9;
        High_Offset = 15;
        Offset_Hammer = 5;
        Offset_ShootStar = 5;
        Offset_Doji = 5;
        Offset_Star = 5;
        Offset_Piercing_Line = 5;
        Offset_DarkCC = 5;
        Offset_Bearish_Engulfing = 5;
        Offset_Bullish_Engulfing = 5;
        Text_ShootStar = 8;
        Text_Hammer = 8;
        Text_Star = 8;
        Text_DarkCC = 8;
        Text_Piercing_Line = 8;
        Text_Bearish_Engulfing = 8;
        Text_Bullish_Engulfing = 8;
        IncOffset = 16;
        break;
    case 15:
        period = "M15";
        Doji_Star_Ratio = 0;
        Piercing_Line_Ratio = 0.5;
        Piercing_Candle_Length = 10;
        Engulfing_Length = 0;
        Candle_WickBody_Percent = 0.9;
        CandleLength = 12;
        Pointer_Offset = 9;
        High_Offset = 15;
        Offset_Hammer = 5;
        Offset_ShootStar = 5;
        Offset_Doji = 5;
        Offset_Star = 5;
        Offset_Piercing_Line = 5;
        Offset_DarkCC = 5;
        Offset_Bearish_Engulfing = 5;
        Offset_Bullish_Engulfing = 5;
        Text_ShootStar = 8;
        Text_Hammer = 8;
        Text_Star = 8;
        Text_DarkCC = 8;
        Text_Piercing_Line = 8;
        Text_Bearish_Engulfing = 8;
        Text_Bullish_Engulfing = 8;
        IncOffset = 16;
        break;
    case 30:
        period = "M30";
        Doji_Star_Ratio = 0;
        Piercing_Line_Ratio = 0.5;
        Piercing_Candle_Length = 10;
        Engulfing_Length = 15;
        Candle_WickBody_Percent = 0.9;
        CandleLength = 12;
        Pointer_Offset = 9;
        High_Offset = 15;
        Offset_Hammer = 5;
        Offset_ShootStar = 5;
        Offset_Doji = 5;
        Offset_Star = 5;
        Offset_Piercing_Line = 5;
        Offset_DarkCC = 5;
        Offset_Bearish_Engulfing = 5;
        Offset_Bullish_Engulfing = 5;
        Text_ShootStar = 8;
        Text_Hammer = 8;
        Text_Star = 8;
        Text_DarkCC = 8;
        Text_Piercing_Line = 8;
        Text_Bearish_Engulfing = 8;
        Text_Bullish_Engulfing = 8;
        IncOffset = 16;
        break;
    case 60:
        period = "H1";
        Doji_Star_Ratio = 0;
        Piercing_Line_Ratio = 0.5;
        Piercing_Candle_Length = 10;
        Engulfing_Length = 25;
        Candle_WickBody_Percent = 0.9;
        CandleLength = 12;
        Pointer_Offset = 9;
        High_Offset = 20;
        Offset_Hammer = 8;
        Offset_ShootStar = 8;
        Offset_Doji = 8;
        Offset_Star = 8;
        Offset_Piercing_Line = 8;
        Offset_DarkCC = 8;
        Offset_Bearish_Engulfing = 8;
        Offset_Bullish_Engulfing = 8;
        Text_ShootStar = 8;
        Text_Hammer = 8;
        Text_Star = 8;
        Text_DarkCC = 8;
        Text_Piercing_Line = 8;
        Text_Bearish_Engulfing = 8;
        Text_Bullish_Engulfing = 8;
        IncOffset = 18;
        break;
    case 240:
        period = "H4";
        Doji_Star_Ratio = 0;
        Piercing_Line_Ratio = 0.5;
        Piercing_Candle_Length = 10;
        Engulfing_Length = 20;
        Candle_WickBody_Percent = 0.9;
        CandleLength = 12;
        Pointer_Offset = 20;
        High_Offset = 40;
        Offset_Hammer = 10;
        Offset_ShootStar = 10;
        Offset_Doji = 10;
        Offset_Star = 10;
        Offset_Piercing_Line = 10;
        Offset_DarkCC = 10;
        Offset_Bearish_Engulfing = 10;
        Offset_Bullish_Engulfing = 10;
        Text_ShootStar = 8;
        Text_Hammer = 8;
        Text_Star = 8;
        Text_DarkCC = 8;
        Text_Piercing_Line = 8;
        Text_Bearish_Engulfing = 8;
        Text_Bullish_Engulfing = 8;
        IncOffset = 25;
        break;
    case 1440:
        period = "D1";
        Doji_Star_Ratio = 0;
        Piercing_Line_Ratio = 0.5;
        Piercing_Candle_Length = 10;
        Engulfing_Length = 30;
        Candle_WickBody_Percent = 0.9;
        CandleLength = 12;
        Pointer_Offset = 20;
        High_Offset = 40;
        Offset_Hammer = 15;
        Offset_ShootStar = 15;
        Offset_Doji = 15;
        Offset_Star = 15;
        Offset_Piercing_Line = 15;
        Offset_DarkCC = 15;
        Offset_Bearish_Engulfing = 15;
        Offset_Bullish_Engulfing = 15;
        Text_ShootStar = 8;
        Text_Hammer = 8;
        Text_Star = 8;
        Text_DarkCC = 8;
        Text_Piercing_Line = 8;
        Text_Bearish_Engulfing = 8;
        Text_Bullish_Engulfing = 8;
        IncOffset = 60;
        break;
    case 10080:
        period = "W1";
        Doji_Star_Ratio = 0;
        Piercing_Line_Ratio = 0.5;
        Piercing_Candle_Length = 10;
        Engulfing_Length = 40;
        Candle_WickBody_Percent = 0.9;
        CandleLength = 12;
        Pointer_Offset = 30;
        High_Offset = 35;
        Offset_Hammer = 20;
        Offset_ShootStar = 20;
        Offset_Doji = 20;
        Offset_Star = 20;
        Offset_Piercing_Line = 20;
        Offset_DarkCC = 20;
        Offset_Bearish_Engulfing = 20;
        Offset_Bullish_Engulfing = 20;
        Text_ShootStar = 8;
        Text_Hammer = 8;
        Text_Star = 8;
        Text_DarkCC = 8;
        Text_Piercing_Line = 8;
        Text_Bearish_Engulfing = 8;
        Text_Bullish_Engulfing = 8;
        IncOffset = 35;
        break;
    case 43200:
        period = "MN";
        Doji_Star_Ratio = 0;
        Piercing_Line_Ratio = 0.5;
        Piercing_Candle_Length = 10;
        Engulfing_Length = 50;
        Candle_WickBody_Percent = 0.9;
        CandleLength = 12;
        Pointer_Offset = 40;
        High_Offset = 45;
        Offset_Hammer = 30;
        Offset_ShootStar = 30;
        Offset_Doji = 30;
        Offset_Star = 30;
        Offset_Piercing_Line = 30;
        Offset_DarkCC = 30;
        Offset_Bearish_Engulfing = 30;
        Offset_Bullish_Engulfing = 30;
        Text_ShootStar = 8;
        Text_Hammer = 8;
        Text_Star = 8;
        Text_DarkCC = 8;
        Text_Piercing_Line = 8;
        Text_Bearish_Engulfing = 8;
        Text_Bullish_Engulfing = 8;
        IncOffset = 45;
        break;
    }

    // ADDED: Check if 5-digit quotes are used and multiply basic offsets
    if (UseExtraDigit)
    {
        Piercing_Candle_Length *= 10;
        Engulfing_Length *= 10;
        Candle_WickBody_Percent *= 10;
        CandleLength *= 10;
        Pointer_Offset *= 10;
        High_Offset *= 10;
        Offset_Hammer *= 10;
        Offset_ShootStar *= 10;
        Offset_Doji *= 10;
        Offset_Star *= 10;
        Offset_Piercing_Line *= 10;
        Offset_DarkCC = 10;
        Offset_Bearish_Engulfing *= 10;
        Offset_Bullish_Engulfing *= 10;
        IncOffset *= 10;
    }
}

void OnDeinit(const int reason)
{
    ObjectsDeleteAll(ChartID(), ObjectPrefix, -1, OBJ_TEXT);
    Comment("");
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
    static datetime prevtime = 0;

    string pattern;

    double O, O1, O2, C, C1, C2, C3, L, L1, L2, L3, H, H1, H2, H3;
    double CL, CL1, CL2, BL, BLa, BL90, UW, LW, BodyHigh, BodyLow;

    if (prevtime == Time[0]) return 0;
    prevtime = Time[0];

    for (int shift = 0; shift < Bars - 9; shift++)
    {
        int CumOffset = 0; // The counter value to be added to as more candle types are met.
        bool setalert = false;

        double Range = 0;
        double AvgRange = 0;
        
        for (int counter = shift ; counter <= shift + 9; counter++)
            AvgRange = AvgRange + MathAbs(High[counter] - Low[counter]);
        Range = AvgRange / 10;
        
        int shift1 = shift + 1;
        int shift2 = shift + 2;
        int shift3 = shift + 3;
        int shift4 = shift + 4;

        O = Open[shift1];
        O1 = Open[shift2];
        O2 = Open[shift3];
        H = High[shift1];
        H1 = High[shift2];
        H2 = High[shift3];
        H3 = High[shift4];
        L = Low[shift1];
        L1 = Low[shift2];
        L2 = Low[shift3];
        L3 = Low[shift4];
        C = Close[shift1];
        C1 = Close[shift2];
        C2 = Close[shift3];
        C3 = Close[shift4];

        if (O > C)
        {
            BodyHigh = O;
            BodyLow = C;
        }
        else
        {
            BodyHigh = C;
            BodyLow = O;
        }

        CL = High[shift1] - Low[shift1];
        CL1 = High[shift2] - Low[shift2];
        CL2 = High[shift3] - Low[shift3];
        BL = Open[shift1] - Close[shift1];
        UW = High[shift1] - BodyHigh;
        LW = BodyLow - Low[shift1];
        BLa = MathAbs(BL);
        BL90 = BLa * Candle_WickBody_Percent;


        // Bearish Patterns

        // Check for Bearish Shooting ShootStar
        if ((H >= H1) && (H > H2) && (H > H3))
        {
            if ((UW / 2 > LW) && (UW > 2 * BL90) && (CL >= CandleLength * Point) && (O != C) && (UW / 3 <= LW) && (UW / 4 <= LW))
            {
                if (Display_ShootStar_2)
                {
                    string name = GetName("SS 2", shift);
                    ObjectCreate(name, OBJ_TEXT, 0, Time[shift1], High[shift1] + (Pointer_Offset + Offset_ShootStar + High_Offset + CumOffset) * Point);
                    ObjectSetText(name, "SS 2", Text_ShootStar, FontFace, Color_ShootStar);
                    ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
                    CumOffset = CumOffset + IncOffset;
                    downArrow[shift1] = High[shift1] + Pointer_Offset * Point;
                }
                if (Show_ShootStar_Alert_2)
                {
                    if ((shift == 0) && (Show_Alert))
                    {
                        pattern = "Shooting ShootStar 2";
                        setalert = true;
                    }
                }
            }
        }
        // Check for Bearish Shooting ShootStar
        if ((H >= H1) && (H > H2) && (H > H3))
        {
            if ((UW / 3 > LW) && (UW > 2 * BL90) && (CL >= CandleLength * Point) && (O != C) && (UW / 4 <= LW))
            {
                if (Display_ShootStar_3)
                {
                    string name = GetName("SS 3", shift);
                    ObjectCreate(name, OBJ_TEXT, 0, Time[shift1], High[shift1] + (Pointer_Offset + Offset_ShootStar + High_Offset + CumOffset) * Point);
                    ObjectSetText(name, "SS 3", Text_ShootStar, FontFace, Color_ShootStar);
                    ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
                    CumOffset = CumOffset + IncOffset;
                    downArrow[shift1] = High[shift1] + Pointer_Offset * Point;
                }
                if (Show_ShootStar_Alert_3)
                {
                    if ((shift == 0) && (Show_Alert))
                    {
                        pattern = "Shooting ShootStar 3";
                        setalert = true;
                    }
                }
            }
        }
        // Check for Bearish Shooting ShootStar
        if ((H >= H1) && (H > H2) && (H > H3))
        {
            if ((UW / 4 > LW) && (UW > 2 * BL90) && (CL >= CandleLength * Point) && (O != C))
            {
                if (Display_ShootStar_4)
                {
                    string name = GetName("SS 4", shift);
                    ObjectCreate(name, OBJ_TEXT, 0, Time[shift1], High[shift1] + (Pointer_Offset + Offset_ShootStar + High_Offset + CumOffset) * Point);
                    ObjectSetText(name, "SS 4", Text_ShootStar, FontFace, Color_ShootStar);
                    ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
                    CumOffset = CumOffset + IncOffset;
                    downArrow[shift1] = High[shift1] + Pointer_Offset * Point;
                }
                if (Show_ShootStar_Alert_4)
                {
                    if ((shift == 0) && (Show_Alert))
                    {
                        pattern = "Shooting ShootStar 4";
                        setalert = true;
                    }
                }
            }
        }
        // Check for Evening Star pattern
        if ((H >= H1) && (H1 > H2) && (H1 > H3))
        {
            if ((BLa < Star_Body_Length * Point) && (C2 > O2) && (O != C) && ((C2 - O2) / (H2 - L2) > Doji_Star_Ratio) && (C1 > O1) && (O > C) && (CL >= Star_MinLength * Point))
            {
                if (Display_Stars)
                {
                    string name = GetName("Star", shift);
                    ObjectCreate(name, OBJ_TEXT, 0, Time[shift1], High[shift1] + (Pointer_Offset + Offset_Star + High_Offset + CumOffset) * Point);
                    ObjectSetText(name, "E_Star", Text_Star, FontFace, Color_Star);
                    ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
                    CumOffset = CumOffset + IncOffset;
                    downArrow[shift1] = High[shift1] + Pointer_Offset * Point;
                }
                if (Show_Stars_Alert)
                {
                    if ((shift == 0) && (Show_Alert))
                    {
                        pattern = "Evening Star Pattern";
                        setalert = true;
                    }
                }
            }
        }
        // Check for Evening Doji Star pattern
        if ((H >= H1) && (H1 > H2) && (H1 > H3))
        {
            if ((O == C) && (C2 > O2) && ((C2 - O2) / (H2 - L2) > Doji_Star_Ratio) && (C1 > O1) && (CL >= Doji_MinLength * Point))
            {
                if (Display_Doji)
                {
                    string name = GetName("Doji", shift);
                    ObjectCreate(name, OBJ_TEXT, 0, Time[shift1], High[shift1] + (Pointer_Offset + Offset_Doji + High_Offset + CumOffset) * Point);
                    ObjectSetText(name, "E_Doji", Text_Doji, FontFace, Color_Doji);
                    ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
                    CumOffset = CumOffset + IncOffset;
                    downArrow[shift1] = High[shift1] + Pointer_Offset * Point;
                }
                if (Show_Doji_Alert)
                {
                    if ((shift == 0) && (Show_Alert))
                    {
                        pattern = "Evening Doji Star Pattern";
                        setalert = true;
                    }
                }
            }
        }
        // Check for a Dark Cloud Cover pattern
        if ((C1 > O1) && ((C1 + O1) / 2 > C) && (O > C) && (C > O1) && ((O - C) / (H - L) > Piercing_Line_Ratio) && ((CL >= Piercing_Candle_Length * Point)))
        {
            if (Display_Dark_Cloud_Cover)
            {
                string name = GetName("DCC", shift);
                ObjectCreate(name, OBJ_TEXT, 0, Time[shift1], High[shift1] + (Pointer_Offset + Offset_DarkCC + High_Offset + CumOffset) * Point);
                ObjectSetText(name, "DCC", Text_DarkCC, FontFace, Color_DarkCC);
                ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
                CumOffset = CumOffset + IncOffset;
                downArrow[shift1] = High[shift1] + Pointer_Offset * Point;
            }
            if (Show_DarkCC_Alert)
            {
                if ((shift == 0) && (Show_Alert))
                {
                    pattern = "Dark Cloud Cover Pattern";
                    setalert = true;
                }
            }
        }
        // Check for Bearish Engulfing pattern
        if ((C1 > O1) && (O > C) && (O >= C1) && (O1 >= C) && (O - C > C1 - O1) && (CL >= Engulfing_Length * Point))
        {
            if (Display_Bearish_Engulfing)
            {
                string name = GetName("S_E", shift);
                ObjectCreate(name, OBJ_TEXT, 0, Time[shift1], High[shift1] + (Pointer_Offset + Offset_Bearish_Engulfing + High_Offset + CumOffset) * Point);
                ObjectSetText(name, "S_E", Text_Bearish_Engulfing, FontFace, Color_Bearish_Engulfing);
                ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
                CumOffset = CumOffset + IncOffset;
                downArrow[shift1] = High[shift1] + Pointer_Offset * Point;
            }
            if (Show_Bearish_Engulfing_Alert)
            {
                if ((shift == 0) && (Show_Alert))
                {
                    pattern = "Bearish Engulfing Pattern";
                    setalert = true;
                }
            }
        }
        // End of Bearish Patterns
        // Bullish Patterns
        // Check for Bullish Hammer
        if ((L <= L1) && (L < L2) && (L < L3))
        {
            if ((LW / 2 > UW) && (LW > BL90) && (CL >= CandleLength * Point) && (O != C) && (LW / 3 <= UW) && (LW / 4 <= UW))
            {
                if (Display_Hammer_2)
                {
                    string name = GetName("HMR 2", shift);
                    ObjectCreate(name, OBJ_TEXT, 0, Time[shift1], Low[shift1] - (Pointer_Offset + Offset_Hammer + CumOffset) * Point);
                    ObjectSetText(name, "HMR 2", Text_Hammer, FontFace, Color_Hammer);
                    ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
                    CumOffset = CumOffset + IncOffset;
                    upArrow[shift1] = Low[shift1] - Pointer_Offset * Point;
                }
                if (Show_Hammer_Alert_2)
                {
                    if ((shift == 0) && (Show_Alert))
                    {
                        pattern = "Bullish Hammer 2";
                        setalert = true;
                    }
                }
            }
        }
        // Check for Bullish Hammer
        if ((L <= L1) && (L < L2) && (L < L3))
        {
            if ((LW / 3 > UW) && (LW > BL90) && (CL >= CandleLength * Point) && (O != C) && (LW / 4 <= UW))
            {
                if (Display_Hammer_3)
                {
                    string name = GetName("HMR 3", shift);
                    ObjectCreate(name, OBJ_TEXT, 0, Time[shift1], Low[shift1] - (Pointer_Offset + Offset_Hammer + CumOffset) * Point);
                    ObjectSetText(name, "HMR 3", Text_Hammer, FontFace, Color_Hammer);
                    ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
                    CumOffset = CumOffset + IncOffset;
                    upArrow[shift1] = Low[shift1] - Pointer_Offset * Point;
                }
                if (Show_Hammer_Alert_3)
                {
                    if ((shift == 0) && (Show_Alert))
                    {
                        pattern = "Bullish Hammer 3";
                        setalert = true;
                    }
                }
            }
        }
        // Check for Bullish Hammer
        if ((L <= L1) && (L < L2) && (L < L3))
        {
            if ((LW / 4 > UW) && (LW > BL90) && (CL >= CandleLength * Point) && (O != C))
            {
                if (Display_Hammer_4)
                {
                    string name = GetName("HMR 4", shift);
                    ObjectCreate(name, OBJ_TEXT, 0, Time[shift1], Low[shift1] - (Pointer_Offset + Offset_Hammer + CumOffset) * Point);
                    ObjectSetText(name, "HMR 4", Text_Hammer, FontFace, Color_Hammer);
                    ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
                    CumOffset = CumOffset + IncOffset;
                    upArrow[shift1] = Low[shift1] - Pointer_Offset * Point;
                }
                if (Show_Hammer_Alert_4)
                {
                    if ((shift == 0) && (Show_Alert))
                    {
                        pattern = "Bullish Hammer 4";
                        setalert = true;
                    }
                }
            }
        }
        // Check for Morning Star
        if ((L <= L1) && (L1 < L2) && (L1 < L3))
        {
            if ((BLa < Star_Body_Length * Point) && (O != C) && (O2 > C2) && ((O2 - C2) / (H2 - L2) > Doji_Star_Ratio) && (O1 > C1) && (C > O) && (CL >= Star_MinLength * Point))
            {
                if (Display_Stars)
                {
                    string name = GetName("Star", shift);
                    ObjectCreate(name, OBJ_TEXT, 0, Time[shift1], Low[shift1] - (Pointer_Offset + Offset_Star + CumOffset) * Point);
                    ObjectSetText(name, "M_Star", Text_Star, FontFace, Color_Star);
                    ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
                    CumOffset = CumOffset + IncOffset;
                    upArrow[shift1] = Low[shift1] - Pointer_Offset * Point;
                }
                if (Show_Stars_Alert)
                {
                    if ((shift == 0) && (Show_Alert))
                    {
                        pattern = "Morning Star Pattern";
                        setalert = true;
                    }
                }
            }
        }
        // Check for Morning Doji Star
        if ((L <= L1) && (L1 < L2) && (L1 < L3))
        {
            if ((O == C) && (O2 > C2) && ((O2 - C2) / (H2 - L2) > Doji_Star_Ratio) && (O1 > C1) && (CL >= Doji_MinLength * Point))
            {
                if (Display_Doji)
                {
                    string name = GetName("Doji", shift);
                    ObjectCreate(name, OBJ_TEXT, 0, Time[shift1], Low[shift1] - (Pointer_Offset + Offset_Doji + CumOffset) * Point);
                    ObjectSetText(name, "M_Doji", Text_Doji, FontFace, Color_Doji);
                    ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
                    CumOffset = CumOffset + IncOffset;
                    upArrow[shift1] = Low[shift1] - Pointer_Offset * Point;
                }
                if (Show_Doji_Alert)
                {
                    if ((shift == 0) && (Show_Alert))
                    {
                        pattern = "Morning Doji Pattern";
                        setalert = true;
                    }
                }
            }
        }
        // Check for Piercing Line pattern
        if ((C1 < O1) && ((O1 + C1) / 2 < C) && (O < C) && ((C - O) / (H - L) > Piercing_Line_Ratio) && (CL >= Piercing_Candle_Length * Point))
        {
            if (Display_Piercing_Line)
            {
                string name = GetName("PrcLn", shift);
                ObjectCreate(name, OBJ_TEXT, 0, Time[shift1], Low[shift1] - (Pointer_Offset + Offset_Piercing_Line + CumOffset) * Point);
                ObjectSetText(name, "P_L", Text_Piercing_Line, FontFace, Color_Piercing_Line);
                ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
                CumOffset = CumOffset + IncOffset;
                upArrow[shift1] = Low[shift1] - Pointer_Offset * Point;
            }
            if (Show_Piercing_Line_Alert)
            {
                if ((shift == 0) && (Show_Alert))
                {
                    pattern = "Piercing Line Pattern";
                    setalert = true;
                }
            }
        }
        // Check for Bullish Engulfing pattern
        if ((O1 > C1) && (C > O) && (C >= O1) && (C1 >= O) && (C - O > O1 - C1) && (CL >= Engulfing_Length * Point))
        {
            if (Display_Bullish_Engulfing)
            {
                string name = GetName("L_E", shift);
                ObjectCreate(name, OBJ_TEXT, 0, Time[shift1], Low[shift1] - (Pointer_Offset + Offset_Bullish_Engulfing + CumOffset) * Point);
                ObjectSetText(name, "L_E", Text_Bullish_Engulfing, FontFace, Color_Bullish_Engulfing);
                ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
                CumOffset = CumOffset + IncOffset;
                upArrow[shift1] = Low[shift1] - Pointer_Offset * Point;
            }
            if (Show_Bullish_Engulfing_Alert)
            {
                if ((shift == 0) && (Show_Alert))
                {
                    pattern = "Bullish Engulfing Pattern";
                    setalert = true;
                }
            }
        }
        // End of Bullish Patterns
       
        if (setalert)
        {
            Alert(Symbol(), " ", period, " ", pattern);
            setalert = false;
        }
    } // End of for loop

    return rates_total;
}

//+------------------------------------------------------------------+
//| Concatenates string and time for a name.                         |
//+------------------------------------------------------------------+
string GetName(string aName, int shift)
{
    return ObjectPrefix + aName + TimeToString(Time[shift]);
}
//+------------------------------------------------------------------+