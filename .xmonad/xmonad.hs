-- Imports
import XMonad
import XMonad.Config.Desktop

import Data.Monoid
import Data.Maybe
import Data.List

import System.IO
import System.Exit

import qualified XMonad.StackSet as W

import XMonad.Util.Loggers
import XMonad.Util.EZConfig
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Place
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops

import XMonad.Actions.Minimize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves -- >.<
import XMonad.Actions.CopyWindow
import XMonad.Actions.WindowGo
import XMonad.Actions.WithAll
import XMonad.Actions.CycleWS
import XMonad.Actions.GridSelect
import XMonad.Actions.DynamicWorkspaces
import XMonad.Actions.MouseResize
import qualified XMonad.Actions.ConstrainedResize as Sqr

import XMonad.Layout.PerWorkspace
import XMonad.Layout.Renamed
import XMonad.Layout.WorkspaceDir
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Layout.LimitWindows
import XMonad.Layout.WindowArranger
import XMonad.Layout.Reflect
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.GridVariants
import XMonad.Layout.SimplestFloat
import XMonad.Layout.OneBig
import XMonad.Layout.ThreeColumns
import XMonad.Layout.LayoutModifier
import XMonad.Layout.ResizableTile
import XMonad.Layout.ZoomRow
import XMonad.Layout.IM
import qualified XMonad.Layout.ToggleLayouts as T

import XMonad.Prompt


-- Config
windowCount     = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ ewmh desktopConfig
        {
        manageHook = ( isFullscreen --> doFullFloat ) <+> myManageHook <+> manageHook desktopConfig <+> manageDocks,
        logHook = dynamicLogWithPP xmobarPP
                        {
                        ppOutput = \x -> hPutStrLn xmproc x,
                        ppCurrent = xmobarColor "#83a598" "" . wrap "[" "]",
                        ppVisible = xmobarColor "#83a598" "",
                        ppHidden = xmobarColor "#b8bb26" "" . wrap "*" "",
                        ppHiddenNoWindows = xmobarColor "#d3869b" "",
                        ppTitle = xmobarColor "#ebdbb2" "" . shorten 70,
                        ppSep =  "<fc=#ebdbb2> : </fc>",
                        ppUrgent = xmobarColor "cc241d" "" . wrap "!" "!",
                        ppExtras  = [windowCount],
                        ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                        },
        modMask            = mod4Mask,
        -- startupHook        = myStartupHook,
        layoutHook         = myLayoutHook,
        workspaces         = myWorkspaces,
        borderWidth        = 1,
        normalBorderColor  = "#665c54",
        focusedBorderColor = "#83a598"
        } `additionalKeysP`   myKeys


-- Keybinds
myKeys =
    [
    ("M-C-r", spawn "stack exec -- xmonad --recompile"),
    ("M-S-r", spawn "stack exec -- xmonad --restart"),
    ("M-S-q", io exitSuccess),

    ("M-S-c",           kill1),
    ("M-S-C-c",         killAll),
    ("M-s",             withFocused $ windows . W.sink),
    ("M-S-s",           sinkAll),

    ("M-m",             windows W.focusMaster),
    ("M-j",             windows W.focusDown),
    ("M-k",             windows W.focusUp),
    ("M-S-m",           windows W.swapMaster),
    ("M-S-j",           windows W.swapDown),
    ("M-S-k",           windows W.swapUp),
    ("M-<Backspace>",   promote),
    ("M1-S-<Tab>",      rotSlavesDown),
    ("M1-C-<Tab>",      rotAllDown),
    ("M-a",             windows copyToAll),
    ("M-S-a",           killAllOtherCopies),

    ("M-C-M1-<Up>",     sendMessage Arrange),
    ("M-C-M1-<Down>",   sendMessage DeArrange),
    ("M-<Up>",          sendMessage (MoveUp 10)),
    ("M-<Down>",        sendMessage (MoveDown 10)),
    ("M-<Right>",       sendMessage (MoveRight 10)),
    ("M-<Left>",        sendMessage (MoveLeft 10)),
    ("M--Up>",        sendMessage (IncreaseUp 10)),
    ("M-S-<Down>",      sendMessage (IncreaseDown 10)),
    ("M-S-<Right>",     sendMessage (IncreaseRight 10)),
    ("M-S-<Left>",      sendMessage (IncreaseLeft 10)),
    ("M-C-<Up>",        sendMessage (DecreaseUp 10)),
    ("M-C-<Down>",      sendMessage (DecreaseDown 10)),
    ("M-C-<Right>",     sendMessage (DecreaseRight 10)),
    ("M-C-<Left>",      sendMessage (DecreaseLeft 10)),

    ("M-<Tab>",             sendMessage NextLayout),
    ("M-S-<Space>",         sendMessage ToggleStruts),
    ("M-S-n",               sendMessage $ Toggle NOBORDERS),
    ("M-S-=",               sendMessage (Toggle NBFULL) >> sendMessage ToggleStruts),
    ("M-S-f",               sendMessage (T.Toggle "float")),
    ("M-<KP_Multiply>",     sendMessage (IncMasterN 1)),
    ("M-<KP_Divide>",       sendMessage (IncMasterN (-1))),
    ("M-S-<KP_Multiply>",   increaseLimit),
    ("M-S-<KP_Divide>",     decreaseLimit),

    ("M-h",     sendMessage Shrink),
    ("M-l",     sendMessage Expand),
    ("M-C-j",   sendMessage MirrorShrink),
    ("M-C-k",   sendMessage MirrorExpand),
    ("M-S-;",   sendMessage zoomReset),
    ("M-;",     sendMessage ZoomFullToggle),

    ("M-<Return>", spawn "st"),

    ("M-S-x", spawn "/home/zoomer/.local/bin/lockscreen"),

    ("M-S-<Return>", spawn "rofi -show run"),

    -- Volume
    ("<XF86AudioMute>",             spawn "amixer set Master toggle"),
    ("<XF86AudioLowerVolume>",      spawn "amixer set Master 5-"),
    ("<XF86AudioRaiseVolume>",      spawn "amixer set Master 5+"),

    -- Capture
    ("M-<XF86AudioMute>",           spawn "amixer set Capture toggle"),
    ("M-<XF86AudioLowerVolume>",    spawn "amixer set Capture 5-"),
    ("M-<XF86AudioRaiseVolume>",    spawn "amixer set Capture 5+"),

    ("<XF86MonBrightnessUp>",   spawn "exec xbacklight -inc 10"),
    ("<XF86MonBrightnessDown>", spawn "exec xbacklight -dec 10"),

    ("<Print>",         spawn "/home/zoomer/.local/bin/screenshot")


    ] where nonNSP          = WSIs (return (\ws -> W.tag ws /= "nsp"))
            nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "nsp"))


-- Workspaces
xmobarEscape = concatMap doubleLts
  where doubleLts '<' = "<<"
        doubleLts x   = [x]

myWorkspaces :: [String]
myWorkspaces = clickable . (map xmobarEscape)
               $ ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
  where clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                      (i,ws) <- zip [1..9] l,
                      let n = i ]
myManageHook :: Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
     [
       isFullscreen --> doFullFloat
     ]

-- Layouts

myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats $
               mkToggle (NBFULL ?? NOBORDERS ?? EOT) $ myDefaultLayout
                   where myDefaultLayout = tall ||| grid  ||| noBorders monocle ||| floats


tall       = renamed [Replace "tall"]     $ limitWindows 12 $ smartBorders $ smartSpacingWithEdge 3 $ ResizableTall 1 (3/100) (1/2) []
grid       = renamed [Replace "grid"]     $ limitWindows 12 $ smartBorders $ smartSpacingWithEdge 3 $ mkToggle (single MIRROR) $ Grid (16/10)
monocle    = renamed [Replace "monocle"]  $ limitWindows 20 $ Full
floats     = renamed [Replace "floats"]   $ limitWindows 20 $ simplestFloat<
