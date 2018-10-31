module MusicTests exposing (all)

import Expect
import Fuzz exposing (Fuzzer)
import MusicTheory.Duration as Duration exposing (..)
import MusicTheory.Key as Key
import MusicTheory.Letter exposing (Letter(..))
import MusicTheory.Music exposing (..)
import MusicTheory.Octave exposing (..)
import MusicTheory.Pitch as Pitch exposing (Pitch, flat, natural, pitch, sharp)
import MusicTheory.Pitch.Spelling as Spelling
import MusicTheory.PitchClass as PitchClass
import MusicTheory.PitchClass.Spelling exposing (Accidental(..))
import Test exposing (..)


twoFiveOne : Music Pitch
twoFiveOne =
    let
        dMinor =
            chord [ dNatural four, fNatural four, aNatural four ] quarterNote

        gMajor =
            chord [ dNatural four, gNatural four, bNatural four ] quarterNote

        cMajor =
            chord [ cNatural four, eNatural four, gNatural four ] quarterNote
    in
    line [ dMinor, gMajor, cMajor ]


childrenSongNumber6 : Music Pitch
childrenSongNumber6 =
    let
        -- base line
        b1 =
            addDuration (dotted quarterNote) [ bNatural three, fSharp four, gNatural four, fSharp four ]

        b2 =
            addDuration (dotted quarterNote) [ bNatural three, eSharp four, fSharp four, eSharp four ]

        b3 =
            addDuration (dotted quarterNote) [ aSharp three, fSharp four, gNatural four, fSharp four ]

        bassLine =
            line [ times 3 b1, times 2 b2, times 4 b3, times 5 b1 ]

        -- main voice
        v1a =
            addDuration eighthNote [ aNatural five, eNatural five, dNatural five, fSharp five, cSharp five, bNatural four, eNatural five, bNatural four ]

        v1b =
            addDuration eighthNote [ cSharp five, bNatural four ]

        v1 =
            line [ v1a, dNatural five quarterNote, v1b ]

        -- bars 12-13
        v2a =
            line
                [ cSharp five (dotted halfNote |> tied)
                , cSharp five (dotted halfNote)
                , fNatural five (dotted halfNote)
                , fNatural five halfNote
                , fSharp five quarterNote
                , fSharp five (halfNote |> tied)
                , fSharp five eighthNote
                , gNatural five eighthNote
                ]

        --bars7-11
        v2b =
            line
                [ addDuration eighthNote [ fSharp five, eNatural five, cSharp five, aSharp four ]
                , aNatural four (dotted quarterNote)
                , addDuration eighthNote [ aSharp four, cSharp five, fSharp five, eNatural five, fSharp five ]
                ]

        -- bars 14-16
        v2c =
            line
                [ gNatural five eighthNote
                , cSharp five eighthNote
                , cSharp six (halfNote |> tied)
                , cSharp six eighthNote
                , dNatural six eighthNote
                , cSharp six eighthNote
                , eNatural five eighthNote
                , rest eighthNote
                , aSharp five eighthNote
                , cNatural five eighthNote
                , cNatural five eighthNote
                , cNatural five quarterNote
                , cNatural five eighthNote
                , cSharp five eighthNote
                ]

        -- bars 17-18.5
        v2d =
            addDuration eighthNote
                [ fSharp five
                , cSharp five
                , eNatural five
                , cSharp five
                , aNatural four
                , aSharp four
                , dNatural five
                , eNatural five
                , fSharp five
                ]

        -- bars 18.5-20
        v2e =
            line
                [ eNatural five quarterNote
                , dNatural five eighthNote
                , dNatural five quarterNote
                , cSharp five eighthNote
                , cSharp five quarterNote
                , bNatural four (eighthNote |> tied)
                , bNatural four halfNote
                , cSharp five eighthNote
                , bNatural five eighthNote
                ]

        --bars21-23
        v2f =
            line
                [ fSharp five eighthNote
                , aNatural five eighthNote
                , bNatural five (halfNote |> tied)
                , bNatural five quarterNote
                , aNatural five eighthNote
                , fSharp five eighthNote
                , eNatural five quarterNote
                , dNatural five eighthNote
                , fSharp five eighthNote
                , eNatural five halfNote
                , dNatural five halfNote
                , fSharp five quarterNote
                ]

        -- bars 24-28
        v2g =
            line
                [ eighthNoteTriplet (cSharp five) (dNatural five) (cSharp five)
                , line
                    [ bNatural four (halfNote |> tied)
                    , bNatural four (dotted halfNote |> tied)
                    , bNatural four (dotted halfNote |> tied)
                    , bNatural four (dotted halfNote)
                    ]
                ]

        v2 =
            line [ v2a, v2b, v2c, v2d, v2e, v2f, v2g ]

        mainVoice =
            seq (times 3 v1) v2
    in
    tempo (dotted halfNote) 69 <|
        key
            (PitchClass.pitchClass E natural |> Key.major)
            (timeSignature 3 4 (par bassLine mainVoice))


all : Test
all =
    describe "Music Tests"
        [ test "get all pitches from a music" <|
            \_ ->
                twoFiveOne
                    |> map Spelling.simple
                    |> toList
                    |> Expect.equal
                        [ Ok { letter = D, accidental = Natural, octave = four }
                        , Ok { letter = F, accidental = Natural, octave = four }
                        , Ok { letter = A, accidental = Natural, octave = four }
                        , Ok { letter = D, accidental = Natural, octave = four }
                        , Ok { letter = G, accidental = Natural, octave = four }
                        , Ok { letter = B, accidental = Natural, octave = four }
                        , Ok { letter = C, accidental = Natural, octave = four }
                        , Ok { letter = E, accidental = Natural, octave = four }
                        , Ok { letter = G, accidental = Natural, octave = four }
                        ]
        , test "children songs 6" <|
            \_ ->
                childrenSongNumber6
                    |> toList
                    |> List.length
                    |> Expect.greaterThan 20
        , test "create tuplets" <|
            \_ ->
                quarterNoteTriplet (cNatural four) (chord [ cNatural four, eNatural four ]) (chord [ cNatural four, eNatural four, gNatural four ])
                    |> map Spelling.simple
                    |> toList
                    |> Expect.equal
                        [ Ok { letter = C, accidental = Natural, octave = four }
                        , Ok { letter = C, accidental = Natural, octave = four }
                        , Ok { letter = E, accidental = Natural, octave = four }
                        , Ok { letter = C, accidental = Natural, octave = four }
                        , Ok { letter = E, accidental = Natural, octave = four }
                        , Ok { letter = G, accidental = Natural, octave = four }
                        ]
        ]