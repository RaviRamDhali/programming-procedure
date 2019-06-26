html

<users-list
	v-for="(item, index) in users"
	v-bind:item="item"
	v-bind:index="index"
	v-bind:key="item.guid">
</users-list>


app.js

// Define a new component
Vue.component('users-list', {
    template: '<h1>{{item.name}}</h1>',
    props: ['item']
})
