import { app } from "gi://Astal?version=3.0"
import { Variable, GLib, bind, exec } from "gi://Astal?version=3.0"
import { Astal, Gtk, Gdk } from "gi://Astal?version=3.0"
import Hyprland from "gi://AstalHyprland"
import Mpris from "gi://AstalMpris"
import Battery from "gi://AstalBattery"
import Wp from "gi://AstalWp"
import Network from "gi://AstalNetwork"
import Tray from "gi://AstalTray"

const idleInhibit = Variable<boolean>(false)

function SysTray() {
    const tray = Tray.get_default()

    return <box className="SysTray">
        {bind(tray, "items").as(items => items.map(item => (
            <menubutton
                tooltipMarkup={bind(item, "tooltipMarkup")}
                usePopover={false}
                actionGroup={bind(item, "actionGroup").as(ag => ["dbusmenu", ag])}
                menuModel={bind(item, "menuModel")}>
                <icon gicon={bind(item, "gicon")} />
            </menubutton>
        )))}
    </box>
}

function Wifi() {
    const network = Network.get_default()
    const wifi = bind(network, "wifi")

    return <box visible={wifi.as(Boolean)}>
        {wifi.as(wifi => wifi && (
            <icon
                tooltipText={bind(wifi, "ssid").as(String)}
                className="Wifi"
                icon={bind(wifi, "iconName")}
            />
        ))}
    </box>

}

function AudioSlider() {
    const speaker = Wp.get_default()?.audio.defaultSpeaker!
    const isShowed = Variable(false)

    return <box className="AudioSlider">
        <button 
            onClicked={() => {
                isShowed.set(!(isShowed.get()))
            }
        }>
            <icon
                icon={bind(speaker, "volumeIcon")}
            />
        </button>
        <box
            visible={bind(isShowed).as(Boolean)}
            css="min-width: 140px"
        >
            <slider
                hexpand
                onDragged={({ value }) => speaker.volume = value}
                value={bind(speaker, "volume")}
            />
        </box>
    </box>
}

function BrightnessSlider() {
    const get = (): number => Number(exec(`brightnessctl g`))
    const getMax = (): number => Number(exec(`brightnessctl m`))
    const isShowed = Variable(false)
    const max = getMax()
    const brightness = Variable(get() / max)

    return <box className="AudioSlider">
        <button
            css="margin-left: 20px;"
            onClicked={() => {
                isShowed.set(!(isShowed.get()))
            }
        }>
            <label
                className="nerd-icon"
                label={bind(brightness).as((val) => {
                    if (val == 1) {
                        return "󰃠"
                    } else if (val > 0.5) {
                        return "󰃟"
                    } else {
                        return "󰃞"
                    }
                })}
            />
        </button>
        <box
            visible={bind(isShowed).as(Boolean)}
            css="min-width: 140px"
        >
            <slider
                hexpand
                onDragged={({ value }) => {
                    brightness.set(value)
                    exec(`brightnessctl s ${Math.floor(value * max)}`)
                }}
                value={bind(brightness)}
            />
        </box>
    </box>
}

function BatteryLevel() {
    const bat = Battery.get_default()

    return <box className="Battery"
        visible={bind(bat, "isPresent")}>
        <icon icon={bind(bat, "batteryIconName")} />
        <label label={bind(bat, "percentage").as(p =>
            `${Math.floor(p * 100)} %`
        )} />
    </box>
}

function Media() {
    const mpris = Mpris.get_default()

    return <box className="Media">
        {bind(mpris, "players").as(ps => ps[0] ? (
            <box>
                <box
                    className="Cover"
                    valign={Gtk.Align.CENTER}
                    css={bind(ps[0], "coverArt").as(cover =>
                        `background-image: url('${cover}');`
                    )}
                />
                <label
                    label={bind(ps[0], "metadata").as(() =>
                        `${ps[0].title} - ${ps[0].artist}`
                    )}
                />
            </box>
        ) : (
            <label label="Nothing Playing" />
        ))}
    </box>
}

function Workspaces() {
    const hypr = Hyprland.get_default()

    return <box className="Workspaces">
        {bind(hypr, "workspaces").as(wss => wss
            .filter(ws => !(ws.id >= -99 && ws.id <= -2)) // filter out special workspaces
            .sort((a, b) => a.id - b.id)
            .map(ws => (
                <button
                    className={bind(hypr, "focusedWorkspace").as(fw =>
                        ws === fw ? "focused" : "")}
                    onClicked={() => ws.focus()}>
                    {ws.id}
                </button>
            ))
        )}
    </box>
}

function FocusedClient() {
    const hypr = Hyprland.get_default()
    const focused = bind(hypr, "focusedClient")

    return <box
        className="Focused"
        visible={focused.as(Boolean)}>
        {focused.as(client => (
            client && <label label={bind(client, "title").as(val => {
                if (val.length > 40) {
                    return val.slice(0, 40) + "..."
                }
                return val
            })} />
        ))}
    </box>
}

function Time({ format = "%a, %e %B %H:%M" }) {
    const time = Variable<string>("").poll(1000, () =>
        GLib.DateTime.new_now_local().format(format)!)

    return <label
        className="Time"
        onDestroy={() => time.drop()}
        label={time()}
    />
}

function IdleInhibit() {
    return <button
        className="IdleInhibit"
        onClicked={() => {
            idleInhibit.set(!(idleInhibit.get()))
        }}>
        <label
            className="nerd-icon"
            label={bind(idleInhibit).as((val) => val ? "󰈈" : "󰈉")}
        />
    </button>
}

export default function Bar(monitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor
    
    return <window
        className="Bar"
        inhibit={bind(idleInhibit).as(Boolean)}
        monitor={monitor}
        layer={Astal.Layer.TOP}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={TOP | LEFT | RIGHT}>
        <centerbox>
            <box hexpand halign={Gtk.Align.START}>
                <Workspaces />
                <FocusedClient />
            </box>
            <box>
                <Time />
            </box>
            <box hexpand halign={Gtk.Align.END} >
                <SysTray />
                <Wifi />
                <BrightnessSlider />
                <AudioSlider />
                <IdleInhibit />
                <BatteryLevel />
            </box>
        </centerbox>
    </window>
}