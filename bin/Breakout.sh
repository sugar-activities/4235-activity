#!/bin/sh
# Author: Bert Freudenberg
# Purpose: Run Breakout080601.pr in Etoys

# arguments are unordered, have to loop
args=""
while [ -n "$2" ] ; do
    case "$1" in
      	-b | --bundle-id)   bundle_id="$2"   ; args="$args BUNDLE_ID $2" ;;
      	-a | --activity-id) activity_id="$2" ; args="$args ACTIVITY_ID $2";;
      	-o | --object-id)   object_id="$2"   ; args="$args OBJECT_ID $2";;
	-u | --uri)         uri="$2"         ; args="$args URI $2";;
	*) echo unknown argument $1 $2 ;;
    esac
    shift;shift
done

# really need bundle id and activity id
if [ -z "$bundle_id" -o -z "$activity_id" ] ; then
  echo ERROR: bundle-id and activity-id arguments required
  echo Aborting
  exit 1
fi

# more useful args
args="$args BUNDLE_PATH $SUGAR_BUNDLE_PATH"

# some debug output
echo launching $bundle_id instance $activity_id
[ -n "$object_id"   ] && echo with journal obj $object_id
[ -n "$uri"         ] && echo loading uri $uri
echo

# sanitize
[ -z "$SUGAR_PROFILE" ] && SUGAR_PROFILE=default
[ -z "$SUGAR_ACTIVITY_ROOT" ] && SUGAR_ACTIVITY_ROOT="$HOME/.sugar/$SUGAR_PROFILE/etoys"

# rainbow-enforced locations
export SQUEAK_SECUREDIR="$SUGAR_ACTIVITY_ROOT/data/private"
export SQUEAK_USERDIR="$SUGAR_ACTIVITY_ROOT/data/MyEtoys"

# make group-writable for rainbow
umask 0002
[ ! -d "$SQUEAK_SECUREDIR" ] && mkdir -p "$SQUEAK_SECUREDIR" && chmod o-rwx "$SQUEAK_SECUREDIR"
[ ! -d "$SQUEAK_USERDIR" ] && mkdir -p "$SQUEAK_USERDIR"

# do not crash on dbus errors
export DBUS_FATAL_WARNINGS=0

# now run Squeak VM with Etoys image
exec etoys \
    -sugarBundleId $bundle_id \
    -sugarActivityId $activity_id \
    --document "Breakout080601.pr" \
    $args
