Vue.component('button-counter', {
    data: function () {
        return {
            count: 0
        }
    },
    props: ['car'],
    template: '<button v-on:click="count++">You clicked {{car.name}} {{car.id}} {{ count }} times.</button>'
});
