{-
  This is my xmonad configuration file.
  There are many like it, but this one is mine.

  If you want to customize this file, the easiest workflow goes
  something like this:
    1. Make a small change.
    2. Hit "super-q", which recompiles and restarts xmonad
    3. If there is an error, undo your change and hit "super-q" again to
       get to a stable place again.
    4. Repeat

  Author:     David Brewer
  Repository: https://github.com/davidbrewer/xmonad-ubuntu-conf
-}

import XMonad
import XMonad.Hooks.SetWMName
import XMonad.Layout.Grid
import XMonad.Layout.ResizableTile
import XMonad.Layout.ThreeColumns
import XMonad.Layout.NoBorders
import XMonad.Layout.Circle
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Spacing
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Fullscreen
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Layout.ShowWName

import Data.Maybe (fromJust)
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..), xmobarStrip, xmobarRaw)
import XMonad.Actions.Plane
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import Data.Ratio ((%))
import XMonad.Util.NamedScratchpad
import XMonad.Layout.Renamed

{-
  Xmonad configuration variables. These settings control some of the
  simpler parts of xmonad's behavior and are straightforward to tweak.
-}

myModMask            = mod4Mask       -- changes the mod key to "super"
myFocusedBorderColor = "#fff"      -- color of focused border
myNormalBorderColor  = "#ccc"      -- color of inactive border
myBorderWidth        = 1              -- width of border around windows
myTerminal           = "alacritty"   -- which terminal software to use

{-
  Xmobar configuration variables. These settings control the appearance
  of text which xmonad is sending to xmobar via the DynamicLog hook.
-}

myTitleColor     = "#eeeeee"  -- color of window title
myTitleLength    = 80         -- truncate window title to this length
myCurrentWSColor = "#ff6188"  -- color of active workspace
myVisibleWSColor = "#78dce8"  -- color of inactive workspace
myHiddenWSColor = "#fff" -- color of hidden workspaces
myHiddenNoWindowsWSColor  = "#4a4a4a"  -- color of hidden workspaces with no windows
myUrgentWSColor  = "#4a4a4a"  -- color of workspace with 'urgent' window
myCurrentWSLeft  = "["        -- wrap active workspace with these
myCurrentWSRight = "]"
myVisibleWSLeft  = "("        -- wrap inactive workspace with these
myVisibleWSRight = ")"
myUrgentWSLeft  = "{"         -- wrap urgent workspace with these
myUrgentWSRight = "}"


{-
  Workspace configuration. Here you can change the names of your
  workspaces. Note that they are organized in a grid corresponding
  to the layout of the number pad.

  I would recommend sticking with relatively brief workspace names
  because they are displayed in the xmobar status bar, where space
  can get tight. Also, the workspace labels are referred to elsewhere
  in the configuration file, so when you change a label you will have
  to find places which refer to it and make a change there as well.

  This central organizational concept of this configuration is that
  the workspaces correspond to keys on the number pad, and that they
  are organized in a grid which also matches the layout of the number pad.
  So, I don't recommend changing the number of workspaces unless you are
  prepared to delve into the workspace navigation keybindings section
  as well.
-}

myWorkspaces =
  [
    "1","2","3","4","5","6","7","8","9"
  ]

{-
  Layout configuration. In this section we identify which xmonad
  layouts we want to use. I have defined a list of default
  layouts which are applied on every workspace, as well as
  special layouts which get applied to specific workspaces.

  Note that all layouts are wrapped within "avoidStruts". What this does
  is make the layouts avoid the status bar area at the top of the screen.
  Without this, they would overlap the bar. You can toggle this behavior
  by hitting "super-b" (bound to ToggleStruts in the keyboard bindings
  in the next section).
-}

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True


tall = renamed [Replace "Tall"]
    $ mySpacing 8
    $ ResizableTall 1 (3/100) (1/2) []

mirrored = renamed [Replace "Mirror"]
    $ mySpacing 8
    $ Mirror (ResizableTall 1 (3/100) (1/2) [])

noBordersFull = noBorders Full

grid = Grid

chatLayout = avoidStruts(noBorders Full)

defaultLayouts = smartBorders(avoidStruts(
  tall
  ||| mirrored
  ||| noBordersFull
  ||| grid ))


-- Here we define some layouts which will be assigned to specific
-- workspaces based on the functionality of that workspace.

-- We are just running Slack on the chat layout. Full screen it.


-- Here we combine our default layouts with our specific, workspace-locked
-- layouts.
myLayouts =
  onWorkspace "2" chatLayout defaultLayouts


{-
  Management hooks. You can use management hooks to enforce certain
  behaviors when specific programs or windows are launched. This is
  useful if you want certain windows to not be managed by xmonad,
  or sent to a specific workspace, or otherwise handled in a special
  way.

  Each entry within the list of hooks defines a way to identify a
  window (before the arrow), and then how that window should be treated
  (after the arrow).

  To figure out to identify your window, you will need to use a
  command-line tool called "xprop". When you run xprop, your cursor
  will temporarily change to crosshairs; click on the window you
  want to identify. In the output that is printed in your terminal,
  look for a couple of things:
    - WM_CLASS(STRING): values in this list of strings can be compared
      to "className" to match windows.
    - WM_NAME(STRING): this value can be compared to "resource" to match
      windows.

  The className values tend to be generic, and might match any window or
  dialog owned by a particular program. The resource values tend to be
  more specific, and will be different for every dialog. Sometimes you
  might want to compare both className and resource, to make sure you
  are matching only a particular window which belongs to a specific
  program.

  Once you've pinpointed the window you want to manipulate, here are
  a few examples of things you might do with that window:
    - doIgnore: this tells xmonad to completely ignore the window. It will
      not be tiled or floated. Useful for things like launchers and
      trays.
    - doFloat: this tells xmonad to float the window rather than tiling
      it. Handy for things that pop up, take some input, and then go away,
      such as dialogs, calculators, and so on.
    - doF (W.shift "Workspace"): this tells xmonad that when this program
      is launched it should be sent to a specific workspace. Useful
      for keeping specific tasks on specific workspaces. In the example
      below I have specific workspaces for chat, development, and
      editing images.
-}

myManagementHooks :: [ManageHook]
myManagementHooks = [
  resource =? "synapse" --> doIgnore
  , resource =? "trayer" --> doIgnore
  , className =? "rdesktop" --> doFloat
  , className =? "notification" --> doFloat
  , className =? "Gnome-calculator" --> doFloat
  , className	=? "Emulator" --> doFloat
  , className	=? "Android Emulator - pixel2:5554"   --> doFloat
  , (className =? "Slack") --> doF (W.shift "6:chat")
  ]

{-
  Here we actually stitch together all the configuration settings
  and run xmonad. We also spawn an instance of xmobar and pipe
  content into it via the logHook.
-}

myKeys :: [(String, X ())]
myKeys = [
    ("M-C-r", spawn "xmonad --recompile")       -- Recompiles xmonad
  , ("M-S-r", spawn "xmonad --restart")
  , ("M-S-k", spawn "chkb")
  , ("M-S-s", spawn "flameshot gui")]

main = do
  xmproc1 <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
  xmproc2 <- spawnPipe "xmobar -x 1 ~/.xmonad/xmobarrc_"

  xmonad $ withUrgencyHook NoUrgencyHook $ def {
    focusedBorderColor = myFocusedBorderColor
  , normalBorderColor = myNormalBorderColor

  , terminal = myTerminal

  , borderWidth = myBorderWidth

  , layoutHook = myLayouts

  , workspaces = myWorkspaces

  , modMask = myModMask

  , handleEventHook = docksEventHook <+> fullscreenEventHook

  , startupHook = do
      setWMName "LG3D"
      spawn "~/.xmonad/startup-hook"

  , manageHook = manageHook def
      <+> composeAll myManagementHooks
      <+> manageDocks

  , logHook = dynamicLogWithPP $ namedScratchpadFilterOutWorkspacePP $ xmobarPP {
      ppOutput = \x -> hPutStrLn xmproc1 x 
                    >> hPutStrLn xmproc2 x

      , ppCurrent = xmobarColor myCurrentWSColor ""
        . wrap ("<fc=" ++ myCurrentWSColor ++ ">") "</fc>"
      , ppHiddenNoWindows = xmobarColor myHiddenNoWindowsWSColor ""
        . wrap ("<fc=" ++ myHiddenNoWindowsWSColor ++ ">") "</fc>"
      , ppVisible = xmobarColor myVisibleWSColor ""
        . wrap ("<fc=" ++ myVisibleWSColor ++ ">") "</fc>" 
      , ppHidden = xmobarColor myHiddenWSColor ""
        . wrap ("<fc=" ++ myHiddenWSColor ++ ">") "</fc>"
      , ppTitle = xmobarColor myTitleColor "" . shorten 50
      , ppLayout = xmobarColor myTitleColor ""
      , ppTitleSanitize = xmobarStrip
      , ppWsSep = "     "
      , ppSep = "                       "
      , ppOrder  = id
    }
  } `additionalKeysP` myKeys
